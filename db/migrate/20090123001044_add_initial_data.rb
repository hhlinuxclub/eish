class AddInitialData < ActiveRecord::Migration
  def self.up
    # Password for user 'foo' is also 'foo'
    User.create(:first_name => "Foo",
                :last_name => "Bar",
                :username => "foo",
                :email => "foo@bar.fb",
                :hashed_password => "af38665a95c971bd8283c2d4b04028340a86c653",
                :salt => "186635600.0815359358741643",
                :role_id => "1")
  end

  def self.down
    User.find_by_username("foo").destroy
  end
end
