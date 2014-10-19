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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141010181045) do

  create_table "event_users", force: true do |t|
    t.integer  "event_id"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_approved"
  end

  create_table "events", force: true do |t|
    t.string   "subject"
    t.string   "location"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "is_all_day"
    t.string   "organizer_mail"
    t.boolean  "is_reccurnce"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "event_id"
  end

  create_table "exchange_importers", force: true do |t|
    t.string   "token"
    t.string   "user_name"
    t.string   "password"
    t.string   "server"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gmail_importers", force: true do |t|
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "refresh_token"
    t.datetime "expiration_date"
  end

  create_table "mail_importers", force: true do |t|
    t.integer  "importer_id"
    t.string   "importer_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "error_count"
  end

  create_table "outlook_importers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_proposals", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "request_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "requests", force: true do |t|
    t.string   "return_mail"
    t.string   "return_name"
    t.string   "location"
    t.string   "subject"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_hours", force: true do |t|
    t.string   "day"
    t.integer  "start_at"
    t.integer  "end_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "day_index"
  end

end
