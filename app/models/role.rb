class Role < ActiveRecord::Base
  has_many :users
  
  def self.no_privileges
    Role.find :first, :conditions => {
      :can_create => false,
      :can_update => false,
      :can_delete => false,
      :can_publish => false,
      :can_administer => false
    }
  end
  
  def privileges
    privileges = []
    
    if can_create?
      privileges << "create content"
      privileges << "edit your own content" unless can_update?
      privileges << "delete your own content" unless can_delete?
    end
    privileges << "edit any content" if can_update?
    privileges << "delete any content" if can_delete?
    privileges << "publish and unpublish content" if can_publish
    privileges << "administer users and settings" if can_administer?
    
    return privileges
  end
end
