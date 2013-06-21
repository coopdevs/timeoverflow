# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130621103501) do

  create_table "categories", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "reg_number_seq"
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.string   "type"
    t.integer  "category_id"
    t.integer  "user_id"
    t.text     "description"
    t.date     "start_on"
    t.date     "end_on"
    t.boolean  "permanent"
    t.boolean  "joinable"
    t.boolean  "global"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "posts", ["category_id"], :name => "index_posts_on_category_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "user_joined_post", :force => true do |t|
    t.integer "user_id"
    t.integer "post_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",            :null => false
    t.string   "email",               :null => false
    t.string   "password_digest"
    t.date     "date_of_birth"
    t.string   "identity_document"
    t.string   "member_code"
    t.integer  "organization_id"
    t.string   "phone"
    t.string   "alt_phone"
    t.text     "address"
    t.date     "registration_date"
    t.integer  "registration_number"
    t.boolean  "admin"
    t.boolean  "superadmin"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.datetime "deleted_at"
    t.string   "gender"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["organization_id"], :name => "index_users_on_organization_id"

end
