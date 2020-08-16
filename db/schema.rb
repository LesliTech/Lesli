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

ActiveRecord::Schema.define(version: 9010104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_locations", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "postal_code"
    t.string "latitude"
    t.string "longitude"
    t.string "code"
    t.string "level"
    t.string "native_level"
    t.bigint "parent_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id", "name", "level", "parent_id"], name: "location_uniqueness_index", unique: true
    t.index ["accounts_id"], name: "index_account_locations_on_accounts_id"
    t.index ["deleted_at"], name: "index_account_locations_on_deleted_at"
    t.index ["name"], name: "index_account_locations_on_name"
  end

  create_table "account_settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_account_settings_on_accounts_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.integer "status"
    t.string "company_name"
    t.string "company_name_legal"
    t.string "company_tag_line"
    t.integer "country"
    t.string "address"
    t.string "region"
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

  create_table "cloud_babel_translation_buckets", force: :cascade do |t|
    t.string "name"
    t.string "reference_module"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_translation_modules_id"
    t.index ["cloud_babel_translation_modules_id"], name: "babel_translation_objects_modules"
  end

  create_table "cloud_babel_translation_modules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_babel_translation_strings", force: :cascade do |t|
    t.string "context"
    t.string "label"
    t.string "es"
    t.string "en"
    t.string "de"
    t.string "fr"
    t.integer "status"
    t.integer "priority"
    t.boolean "need_help"
    t.boolean "need_translation"
    t.string "reference_bucket"
    t.datetime "last_update_context"
    t.datetime "last_update_es"
    t.datetime "last_update_en"
    t.datetime "last_update_de"
    t.datetime "last_update_fr"
    t.datetime "last_update_status"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_babel_translation_buckets_id"
    t.index ["cloud_babel_translation_buckets_id"], name: "babel_translation_strings_buckets"
    t.index ["users_id"], name: "babel_translation_strings_users"
  end

  create_table "cloud_babel_translations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_bell_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_bell_accounts_on_deleted_at"
  end

  create_table "cloud_bell_notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "url"
    t.string "category"
    t.string "sender"
    t.boolean "read", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_bell_accounts_id"
    t.index ["cloud_bell_accounts_id"], name: "index_cloud_bell_notifications_on_cloud_bell_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_bell_notifications_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_bell_notifications_on_users_id"
  end

  create_table "role_details", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.string "default_path"
    t.boolean "only_my_data", default: false
    t.integer "object_level_permission", default: 10
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "roles_id"
    t.index ["deleted_at"], name: "index_role_details_on_deleted_at"
    t.index ["roles_id"], name: "index_role_details_on_roles_id"
  end

  create_table "role_overrides", force: :cascade do |t|
    t.string "grant_object"
    t.boolean "grant_index", default: false
    t.boolean "grant_edit", default: false
    t.boolean "grant_show", default: false
    t.boolean "grant_new", default: false
    t.boolean "grant_create", default: false
    t.boolean "grant_update", default: false
    t.boolean "grant_destroy", default: false
    t.boolean "grant_options", default: false
    t.boolean "grant_default", default: false
    t.boolean "grant_search", default: false
    t.boolean "grant_empty", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["deleted_at"], name: "index_role_overrides_on_deleted_at"
    t.index ["users_id"], name: "index_role_overrides_on_users_id"
  end

  create_table "role_privilege_defaults", force: :cascade do |t|
    t.string "grant_object"
    t.boolean "grant_index", default: false
    t.boolean "grant_edit", default: false
    t.boolean "grant_show", default: false
    t.boolean "grant_new", default: false
    t.boolean "grant_create", default: false
    t.boolean "grant_update", default: false
    t.boolean "grant_destroy", default: false
    t.boolean "grant_search", default: false
    t.boolean "grant_resources", default: false
    t.boolean "grant_options", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "roles_id"
    t.index ["deleted_at"], name: "index_role_privilege_defaults_on_deleted_at"
    t.index ["roles_id"], name: "index_role_privilege_defaults_on_roles_id"
  end

  create_table "role_privileges", force: :cascade do |t|
    t.string "grant_object"
    t.boolean "grant_index", default: false
    t.boolean "grant_edit", default: false
    t.boolean "grant_show", default: false
    t.boolean "grant_new", default: false
    t.boolean "grant_create", default: false
    t.boolean "grant_update", default: false
    t.boolean "grant_destroy", default: false
    t.boolean "grant_search", default: false
    t.boolean "grant_resources", default: false
    t.boolean "grant_options", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "roles_id"
    t.index ["deleted_at"], name: "index_role_privileges_on_deleted_at"
    t.index ["roles_id"], name: "index_role_privileges_on_roles_id"
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_roles_on_accounts_id"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "user_activities", force: :cascade do |t|
    t.string "request_controller"
    t.string "request_method"
    t.string "request_action"
    t.string "request_url"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_user_activities_on_users_id"
  end

  create_table "user_details", force: :cascade do |t|
    t.string "title"
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "telephone"
    t.string "address"
    t.integer "work_city"
    t.integer "work_region"
    t.integer "work_address"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["deleted_at"], name: "index_user_details_on_deleted_at"
    t.index ["users_id"], name: "index_user_details_on_users_id"
  end

  create_table "user_settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_user_settings_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "active", default: true, null: false
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
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "roles_id"
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["roles_id"], name: "index_users_on_roles_id"
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "account_locations", "account_locations", column: "parent_id"
  add_foreign_key "account_locations", "accounts", column: "accounts_id"
  add_foreign_key "account_settings", "accounts", column: "accounts_id"
  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
  add_foreign_key "role_details", "roles", column: "roles_id"
  add_foreign_key "role_overrides", "users", column: "users_id"
  add_foreign_key "role_privilege_defaults", "roles", column: "roles_id"
  add_foreign_key "role_privileges", "roles", column: "roles_id"
  add_foreign_key "roles", "accounts", column: "accounts_id"
  add_foreign_key "user_activities", "users", column: "users_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "user_settings", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "roles", column: "roles_id"
end
