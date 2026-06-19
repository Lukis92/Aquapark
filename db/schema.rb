# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2026_06_19_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "active"
    t.string "day_of_week", null: false
    t.time "start_on", null: false
    t.time "end_on", null: false
    t.string "pool_zone", null: false
    t.integer "max_people"
    t.integer "person_id"
    t.index ["person_id"], name: "index_activities_on_person_id"
  end

  create_table "activities_people", id: :serial, force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "person_id", null: false
    t.date "date"
    t.index ["activity_id", "person_id"], name: "index_activities_people_on_activity_id_and_person_id"
    t.index ["person_id", "activity_id"], name: "index_activities_people_on_person_id_and_activity_id"
  end

  create_table "bought_details", id: :serial, force: :cascade do |t|
    t.datetime "bought_data", precision: nil, null: false
    t.date "start_on"
    t.date "end_on", null: false
    t.integer "entry_type_id"
    t.integer "person_id"
    t.decimal "cost", precision: 5, scale: 2, null: false
    t.index ["entry_type_id"], name: "index_bought_details_on_entry_type_id"
    t.index ["person_id"], name: "index_bought_details_on_person_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "person_id"
    t.integer "news_id"
    t.index ["news_id"], name: "index_comments_on_news_id"
    t.index ["person_id"], name: "index_comments_on_person_id"
  end

  create_table "entry_types", id: :serial, force: :cascade do |t|
    t.string "kind", null: false
    t.string "kind_details", null: false
    t.text "description"
    t.decimal "price", precision: 5, scale: 2, null: false
  end

  create_table "individual_trainings", id: :serial, force: :cascade do |t|
    t.date "date_of_training", null: false
    t.integer "client_id"
    t.integer "trainer_id"
    t.time "start_on", null: false
    t.time "end_on", null: false
    t.integer "training_cost_id"
    t.index ["client_id"], name: "index_individual_trainings_on_client_id"
    t.index ["trainer_id"], name: "index_individual_trainings_on_trainer_id"
    t.index ["training_cost_id"], name: "index_individual_trainings_on_training_cost_id"
  end

  create_table "likes", id: :serial, force: :cascade do |t|
    t.boolean "like"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "person_id"
    t.integer "news_id"
    t.index ["news_id"], name: "index_likes_on_news_id"
    t.index ["person_id"], name: "index_likes_on_person_id"
  end

  create_table "news", id: :serial, force: :cascade do |t|
    t.string "title", null: false
    t.text "content", null: false
    t.string "scope", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_news_on_person_id"
  end

  create_table "people", id: :serial, force: :cascade do |t|
    t.string "pesel", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "date_of_birth", null: false
    t.string "email", null: false
    t.string "type", null: false
    t.decimal "salary", precision: 6, scale: 2
    t.date "hiredate"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_people_on_email", unique: true
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
  end

  create_table "pg_search_documents", id: :serial, force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.integer "searchable_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 12, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "training_costs", id: :serial, force: :cascade do |t|
    t.integer "duration", null: false
    t.decimal "cost", precision: 5, scale: 2, null: false
  end

  create_table "vacations", id: :serial, force: :cascade do |t|
    t.date "start_at", null: false
    t.date "end_at", null: false
    t.boolean "free", default: false, null: false
    t.text "reason"
    t.integer "person_id"
    t.boolean "accepted", default: false
    t.index ["person_id"], name: "index_vacations_on_person_id"
  end

  create_table "work_schedules", id: :serial, force: :cascade do |t|
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.string "day_of_week", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "person_id"
    t.index ["person_id"], name: "index_work_schedules_on_person_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "people"
  add_foreign_key "bought_details", "entry_types"
  add_foreign_key "bought_details", "people"
  add_foreign_key "comments", "news"
  add_foreign_key "comments", "people"
  add_foreign_key "individual_trainings", "people", column: "client_id"
  add_foreign_key "individual_trainings", "people", column: "trainer_id"
  add_foreign_key "individual_trainings", "training_costs"
  add_foreign_key "likes", "news"
  add_foreign_key "likes", "people"
  add_foreign_key "news", "people"
  add_foreign_key "vacations", "people"
  add_foreign_key "work_schedules", "people"
end
