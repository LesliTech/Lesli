# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2040109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "status"
    t.string "company_name"
    t.string "company_name_legal"
    t.string "company_tag_line"
    t.string "address"
    t.string "website"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "phone_number_3"
    t.string "phone_number_4"
    t.string "public_email"
    t.string "github"
    t.string "twitter"
    t.string "youtube"
    t.string "linkedin"
    t.string "facebook"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_accounts_on_users_id"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "cloud_house_accounts", force: :cascade do |t|
  end

  create_table "cloud_house_contact_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_actions_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_activities_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_custom_field_values", force: :cascade do |t|
    t.datetime "value_datetime"
    t.integer "value_integer"
    t.boolean "value_boolean"
    t.string "value_string"
    t.json "value_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contact_custom_fields_id"
    t.index ["cloud_house_contact_custom_fields_id"], name: "house_contact_custom_field_values_custom_fields"
  end

  create_table "cloud_house_contact_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_custom_fields_contacts"
    t.index ["users_id"], name: "index_cloud_house_contact_custom_fields_on_users_id"
  end

  create_table "cloud_house_contact_details", force: :cascade do |t|
    t.string "salutation"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "birthdate"
    t.string "birthplace"
    t.string "nationality"
    t.string "email"
    t.string "telephone"
    t.string "mobile_number"
    t.string "fax_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_details_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contact_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contact_discussions_id"], name: "house_contact_discussions_discussions"
    t.index ["cloud_house_contacts_id"], name: "house_contact_discussions_contacts"
    t.index ["users_id"], name: "index_cloud_house_contact_discussions_on_users_id"
  end

  create_table "cloud_house_contact_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_files_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_subscribers_contacts"
    t.index ["users_id"], name: "house_contact_subscribers_users"
  end

  create_table "cloud_house_contacts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_contacts_on_cloud_house_accounts_id"
    t.index ["users_id"], name: "index_cloud_house_contacts_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_contact_actions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_activities", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_custom_field_values", "cloud_house_contact_custom_fields", column: "cloud_house_contact_custom_fields_id"
  add_foreign_key "cloud_house_contact_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_details", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contact_discussions", column: "cloud_house_contact_discussions_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_files", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contacts", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_contacts", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
