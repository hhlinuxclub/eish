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

ActiveRecord::Schema.define(:version => 20090123001044) do

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.text     "body"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",   :default => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "location"
    t.text     "description"
    t.integer  "user_id"
    t.boolean  "published",   :default => false
    t.boolean  "is_address",  :default => false
  end

  create_table "galleries", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries_images", :id => false, :force => true do |t|
    t.integer "gallery_id"
    t.integer "image_id"
  end

  add_index "galleries_images", ["gallery_id", "image_id"], :name => "index_galleries_images_on_gallery_id_and_image_id", :unique => true
  add_index "galleries_images", ["gallery_id"], :name => "index_galleries_images_on_gallery_id"
  add_index "galleries_images", ["image_id"], :name => "index_galleries_images_on_image_id"

  create_table "images", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.boolean  "published",  :default => false
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
  end

end
