require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role
  has_many :articles
  has_many :revisions
  has_many :events
  has_many :galleries
  has_many :images
  has_many :news
  has_many :assets
  has_many :galleries
  has_one :profile

  validates_presence_of :first_name, :last_name, :username, :email
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
  validates_confirmation_of :password
  validate :password_non_blank
  validates_size_of :username, :minimum => 3
  validates_size_of :password, :minimum => 6, :if => Proc.new { |user| !user.password.empty? && !user.password_confirmation.empty? }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  
  attr_accessor :password_confirmation, :current_password, :remember
  attr_reader :password
  attr_protected :role, :role_id, :hashed_password, :salt
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def self.authenticate(username, password)
    user = User.find_by_username(username)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    return user
  end
  
  def remember
    self.remember_token_expires = 2.weeks.from_now
    string_to_hash = salt + self.email + self.remember_token_expires.to_s
    self.remember_token = Digest::SHA1.hexdigest(string_to_hash)
    self.password = ""
    self.save_with_validation(false)
  end
  
  def forget
    self.remember_token_expires = nil
    self.remember_token = nil
    self.password = ""
    self.save_with_validation(false)
  end
  
  def before_create
    Mailer.deliver_welcome(self)
    self.profile = Profile.new
    self.role = Role.no_privileges
  end
  
  def has_content?
    [Article, Revision, Event, News, Asset, Gallery].each do |model|
      return true if !model.find_by_user_id(self.id).nil?
    end
    return false
  end
  
  def before_destroy
    !self.has_content?
  end
  
  def safe_destroy
    if self.has_content?
      self.username = nil 
      self.email = nil
      self.hashed_password = nil
      self.salt = nil
      self.role_id = nil
      self.remember_token = nil
      self.remember_token_expires = nil
      self.reset_hash = nil
      self.reset_hash_expires = nil
      self.profile.destroy
      self.save_with_validation(false)
    else
      self.destroy
    end
  end
  
  def self.all_current_users
    find(:all, :conditions => "username IS NOT NULL", :order => "role_id")
  end
  
  def name_with_role
    if !role_id.nil?
      return name + ", " + self.role.name
    else
      return name
    end
  end
  
  def title_or_role
    if self.title.nil? || self.title.empty?
      return self.role.name
    else
      return self.title
    end
  end
  
  def name
    return self.first_name + " " + self.last_name
  end
  
  def name_with_title
    if self.role_id.nil?
      return name
    else
      return name + ", " + title_or_role
    end
  end
  
  def generate_reset_hash
    self.reset_hash = Digest::SHA1.hexdigest(username + self.object_id.to_s + rand.to_s)
    self.reset_hash_expires = 24.hours.from_now
    self.save
  end
  
  def reset_password(new_password, reset_hash)
    if reset_hash == self.reset_hash && reset_hash_expires > Time.now
      self.password = new_password
      self.reset_hash = nil
      self.reset_hash_expires = nil
      self.save
    else
      return false
    end
  end
  
  def normal_user?
    return self.role.id == Role.no_privileges.id
  end
  
  def to_param
    username
  end
  
  private
    
    def password_non_blank
      errors.add_to_base("Missing password") if hashed_password.blank?
    end
    
    def self.encrypted_password(password, salt)
      string_to_hash = password + "hhlc" + salt
      Digest::SHA1.hexdigest(string_to_hash)
    end
    
    def create_new_salt
      self.salt = self.object_id.to_s + rand.to_s
    end
end
