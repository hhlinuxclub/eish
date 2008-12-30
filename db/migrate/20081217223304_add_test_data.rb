class AddTestData < ActiveRecord::Migration
  def self.up
    Article.delete_all
    News.delete_all
    Event.delete_all
    User.delete_all
    
    # Password for user 'foo' is also 'foo'
    User.create(:first_name => "Foo",
                :last_name => "Bar",
                :username => "foo",
                :email => "foo@bar.fb",
                :hashed_password => "af38665a95c971bd8283c2d4b04028340a86c653",
                :salt => "186635600.0815359358741643",
                :role_id => "1")
    
    Article.create( :title => "Gentoo Linux",
                    :description => "This article is about Gentoo Linux.",
                    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    :user_id => 1)
    
    Article.create( :title => "Arch Linux",
                    :description => "This article is about Arch Linux.",
                    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    :user_id => 1)
                    
    Article.create( :title => "System Administration",
                    :description => "This article is about system administration.",
                    :body => "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                    :user_id => 1)
                    
    News.create(:title => "Welcome (again)",
                :body => "Welcome to the redesigned website of the HHLC.",
                :user_id => 1)
                
    News.create(:title => "Under development",
                :body => "As you can see, this website is not ready. It is under development.",
                :user_id => 1)
                
    Event.create( :name => "Christmas Party",
                  :starts_at => "2008-12-25 00:00",
                  :ends_at => "2008-12-25 23:59",
                  :location => "Home",
                  :description => "Christmas with your loved ones.",
                  :user_id => 1)
                  
    Event.create( :name => "New Year",
                  :starts_at => "2009-01-01 00:00",
                  :ends_at => "2009-12-31 23:59",
                  :location => "Everywhere",
                  :description => "The year 2009.",
                  :user_id => 1)
  end

  def self.down
    Article.delete_all
    News.delete_all
    Event.delete_all
    User.delete_all
  end
end
