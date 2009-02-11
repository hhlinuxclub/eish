require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role
  has_many :articles
  has_many :events
  has_many :galleries
  has_many :images
  has_many :news

  validates_presence_of :first_name, :last_name, :username, :email
  validates_uniqueness_of :username, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false
#  validates_size_of :username, :minimum => 4
#  validates_size_of :password, :minimum => 6
  
  attr_accessor :password_confirmation
  attr_accessor :current_password
  attr_accessor :remember_me
  
  validates_confirmation_of :password
  
  validate :password_non_blank
  
  def password
    @password
  end
  
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
  
  def remember_me
    self.remember_token_expires = 2.weeks.from_now
    string_to_hash = salt + self.email + self.remember_token_expires.to_s
    self.remember_token = Digest::SHA1.hexdigest(string_to_hash)
    self.password = ""
    self.save_with_validation(false)
  end
  
  def forget_me
    self.remember_token_expires = nil
    self.remember_token = nil
    self.password = ""
    self.save_with_validation(false)
  end
  
  def before_create
    Mailer.deliver_welcome(self)
  end
  
  def has_content?
    [Article, Event, News].each do |model|
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
      self.save_with_validation(false)
    else
      self.destroy
    end
  end
  
  def self.all_current_users
    find(:all, :conditions => "username IS NOT NULL", :order => "role_id")
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
