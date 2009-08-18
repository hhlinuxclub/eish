namespace :eish do
  desc "Setup the web application: create the database tables and populate initial data."
  task :setup do
    run_git_commands
    
    Rake::Task["environment"].invoke
    
    puts "The database is now going to be created and populated with the default settings."
    puts "Default settings can be found in '#{RAILS_ROOT}/config/default_settings.yml'."
    puts "If you wish, you can change the default settings and then run this task again."
    puts "Settings can later be changed from the website administration."
    
    if confirmation("Do you wish to proceed?", true)
      if ActiveRecord::Migrator.current_version == 0
        ActiveRecord::Base.transaction do
          puts "Creating the database schema..."
          Rake::Task["db:schema:load"].invoke
          puts "Database schema successfully created!\n\n"
          
          puts "Adding roles to the database..."
          Role.create!(:name => "Administrator", :can_create => true, :can_update => true, :can_delete => true, :can_publish => true, :can_administer => true) 
          Role.create!(:name => "Manager", :can_create => true, :can_update => true, :can_delete => true, :can_publish => true, :can_administer => false)
          Role.create!(:name => "Reviewer", :can_create => true, :can_update => true, :can_delete => false, :can_publish => true, :can_administer => false)
          Role.create!(:name => "Contributor", :can_create => true, :can_update => false, :can_delete => false, :can_publish => false, :can_administer => false)
          Role.create!(:name => "Normal User", :can_create => false, :can_update => false, :can_delete => false, :can_publish => false, :can_administer => false)
          puts "Roles successfully added to the database!\n\n"
          
          puts "Adding settings to the database..."
          YAML.load_file("#{RAILS_ROOT}/config/default_settings.yml").each do |option, value|
            Setting.create!(:option => option, :value => value)
            puts "-- " + option + ": " + value.to_s
          end
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
          user = User.new(:username => values[0], :password => values[1], :first_name => values[2], :last_name => values[3], :email => values[4], :contactable => true)
          user.role = Role.find_by_can_administer(true)
          user.save!
          puts "User '#{user.username}' successfully created!\n\n"
          
          puts "Setup is finished! You are now ready to run the web application."
        end
      else
        puts "The configured database for the '#{RAILS_ENV}' environment has data. Aborting!"
      end
    else
      puts "Setup aborted!"
    end
  end
  
  desc "Update the web application: add news settings and update git submodules."
  task :update do
    run_git_commands
    
    Rake::Task["environment"].invoke
    
    puts "Updating the settings table..."
    ActiveRecord::Base.transaction do
      YAML.load_file("#{RAILS_ROOT}/config/default_settings.yml").each do |option, value|
        if Setting.find_by_option(option)
          puts "-- (exists) " + option
        else
          Setting.create!(:option => option, :value => value) 
          puts "-- (new) " + option + ": " + value.to_s
        end
      end
    end
    puts "Settings update finished!\n\n"
    
    puts "Update complete!"
  end
end

def confirmation(question, default_yes=false)
  print question
  print default_yes ? " (Y/n): " : " (y/N): "
  answer = STDIN.gets.chomp
  if ["y", "yes"].include? answer.downcase
    return true
  elsif ["n", "no"].include? answer.downcase
    return  false
  elsif answer.empty?
    return default_yes
  else
    confirmation(question, default_yes)
  end
end

def run_git_commands
  puts "Running command 'git submodule init'..."
  puts `git submodule init`
  puts "Command 'git submodule init' finished executing!\n\n"
  
  puts "Running command 'git submodule update'..."
  puts `git submodule update`
  puts "Command 'git submodule update' finished executing!\n\n"
end
