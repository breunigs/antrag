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

ActiveRecord::Schema.define(:version => 20120415163557) do

  create_table "attachments", :force => true do |t|
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "motion_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "ip"
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.string   "motion_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "ip"
  end

  create_table "fachschaften", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.string   "url"
    t.string   "address"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fachschaften_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "fachschaft_id"
  end

  create_table "motions", :id => false, :force => true do |t|
    t.string   "kind"
    t.string   "title"
    t.text     "text"
    t.string   "contact_mail"
    t.string   "contact_name"
    t.string   "contact_fon"
    t.string   "ident"
    t.date     "publication"
    t.string   "status"
    t.float    "fin_expected_amount"
    t.float    "fin_charged_amount"
    t.boolean  "fin_deducted"
    t.boolean  "fin_granted"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "uuid"
    t.integer  "referat_id"
    t.text     "dynamic_fields"
    t.string   "top"
    t.text     "references"
  end

  create_table "referate", :force => true do |t|
    t.string   "name"
    t.string   "mail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "referate_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "referat_id"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "groups"
  end

  create_table "votes", :force => true do |t|
    t.string   "result"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "motion_id"
    t.integer  "fachschaft_id"
  end

end
