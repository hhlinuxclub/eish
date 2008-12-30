class AddRolesData < ActiveRecord::Migration
  def self.up
    # SECURITY RISK: DO NOT CHANGE ANYTHING ELSE THAN THE NAME OF THE ROLES!
    # Many important bits of code have hardcoded ids.
    Role.create(:id => 1,
                :name => "Administrator", 
                :can_create => true, 
                :can_update => true, 
                :can_delete => true, 
                :can_publish => true, 
                :can_administer => true)
                
    Role.create(:id => 2,
                :name => "Manager", 
                :can_create => true, 
                :can_update => true, 
                :can_delete => true, 
                :can_publish => true, 
                :can_administer => false)
                
    Role.create(:id => 3,             
                :name => "Reviewer", 
                :can_create => true, 
                :can_update => true, 
                :can_delete => false, 
                :can_publish => true, 
                :can_administer => false)
    
    Role.create(:id => 4,
                :name => "Contributor", 
                :can_create => true, 
                :can_update => true, 
                :can_delete => false, 
                :can_publish => false, 
                :can_administer => false)
                
    Role.create(:id => 5,            
                :name => "Normal User", 
                :can_create => false, 
                :can_update => false, 
                :can_delete => false, 
                :can_publish => false, 
                :can_administer => false)                    
  end

  def self.down
    Role.delete_all
  end
end
