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

ActiveRecord::Schema.define(version: 20160429085520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bought_details", force: :cascade do |t|
    t.datetime "bought_data",                           null: false
    t.date     "end_on",                                null: false
    t.integer  "entry_type_id"
    t.integer  "person_id"
    t.date     "start_on"
    t.decimal  "cost",          precision: 5, scale: 2, null: false
  end

  add_index "bought_details", ["entry_type_id"], name: "index_bought_details_on_entry_type_id", using: :btree
  add_index "bought_details", ["person_id"], name: "index_bought_details_on_person_id", using: :btree

  create_table "entry_types", force: :cascade do |t|
    t.string  "kind",                                 null: false
    t.string  "kind_details",                         null: false
    t.text    "description"
    t.decimal "price",        precision: 5, scale: 2, null: false
  end

  create_table "individual_trainings", force: :cascade do |t|
    t.decimal  "cost",             precision: 7, scale: 2, null: false
    t.datetime "date_of_training",                         null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "pesel",                                                           null: false
    t.string   "first_name",                                                      null: false
    t.string   "last_name",                                                       null: false
    t.date     "date_of_birth",                                                   null: false
    t.string   "email",                                                           null: false
    t.string   "type",                                                            null: false
    t.decimal  "salary",                     precision: 6, scale: 2
    t.date     "hiredate"
    t.string   "encrypted_password",                                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree

  create_table "vacations", force: :cascade do |t|
    t.date    "start_at",                  null: false
    t.date    "end_at",                    null: false
    t.boolean "free",      default: false, null: false
    t.text    "reason"
    t.integer "person_id"
  end

  add_index "vacations", ["person_id"], name: "index_vacations_on_person_id", using: :btree

  create_table "work_schedules", force: :cascade do |t|
    t.time     "start_time",  null: false
    t.time     "end_time",    null: false
    t.string   "day_of_week", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "person_id"
  end

  add_index "work_schedules", ["person_id"], name: "index_work_schedules_on_person_id", using: :btree

  add_foreign_key "bought_details", "entry_types"
  add_foreign_key "bought_details", "people"
  add_foreign_key "vacations", "people"
end
