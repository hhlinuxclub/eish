# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090428213937) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",           :default => false
    t.integer  "current_revision_id"
  end

  create_table "assets", :force => true do |t|
    t.string   "description"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.integer  "user_id"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categorizations", :id => false, :force => true do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "published",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "published",  :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.string   "url"
    t.text     "about"
    t.string   "degree_programme"
    t.integer  "graduation_year"
    t.string   "distribution"
    t.string   "desktop_environment"
    t.string   "text_editor"
    t.string   "programming_language"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "revisions", :force => true do |t|
    t.integer  "number"
    t.string   "title"
    t.string   "description"
    t.text     "body"
    t.integer  "article_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string  "name"
    t.boolean "can_create",     :default => false
    t.boolean "can_update",     :default => false
    t.boolean "can_delete",     :default => false
    t.boolean "can_publish",    :default => false
    t.boolean "can_administer", :default => false
  end

  create_table "settings", :force => true do |t|
    t.string   "option"
    t.text     "value",      :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["option"], :name => "index_settings_on_option", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "hashed_password"
    t.string   "salt"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires"
    t.boolean  "contactable",            :default => false
    t.string   "reset_hash"
    t.datetime "reset_hash_expires"
    t.string   "title"
  end

end
