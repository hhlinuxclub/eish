class Role < ActiveRecord::Base
  has_many :users
  
  def self.no_privileges
    roles = Role.all
    for role in roles
      if !role.can_create? && !role.can_update? && !role.can_delete? && !role.can_publish && !role.can_administer?
        return role
      end
    end
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
