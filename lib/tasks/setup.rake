desc "Setup the web application: create the database tables and populate initial data."
task :setup do  
  puts "Creating the database schema..."
  Rake::Task["db:schema:load"].invoke
  puts "Database schema successfully created!\n\n"
  
  puts "Adding roles to the database..."
  Role.create(:id => 1, :name => "Administrator", :can_create => true, :can_update => true, :can_delete => true, :can_publish => true, :can_administer => true) 
  Role.create(:id => 2, :name => "Manager", :can_create => true, :can_update => true, :can_delete => true, :can_publish => true, :can_administer => false)
  Role.create(:id => 3, :name => "Reviewer", :can_create => true, :can_update => true, :can_delete => false, :can_publish => true, :can_administer => false)
  Role.create(:id => 4, :name => "Contributor", :can_create => true, :can_update => true, :can_delete => false, :can_publish => false, :can_administer => false)
  Role.create(:id => 5, :name => "Normal User", :can_create => false, :can_update => false, :can_delete => false, :can_publish => false, :can_administer => false)
  puts "Roles successfully added to the database!\n\n"
  
  puts "Adding settings to the database..."
  Setting.create(:option => "welcome_message", :value => "Welcome to our website.")
  Setting.create(:option => "about", :value => "About us...")
  Setting.create(:option => "featured_article")
  puts "Settings successfully added to the database!\n\n"
  
  puts "Create the initial administrator:"
  values = []
  ["Username", "Password", "First name", "Last name", "Email"].each do |option|
    begin
      print option + ": "
      value = STDIN.gets.chomp
    end while value.empty?
    values << value
  end
  User.create(:username => values[0], :password => values[1], :first_name => values[2], :last_name => values[3], :email => values[4], :role_id => Role.find_by_can_administer(true).id, :contactable => true)
  puts "User '#{values[0]}' successfully created!\n\n"
  
  puts "Setup is finished! You are now ready to run the web application."
end