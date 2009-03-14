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
end
