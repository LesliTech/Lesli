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

ActiveRecord::Schema.define(version: 8020207) do

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

  create_table "cloud_lock_accounts", force: :cascade do |t|
  end

  create_table "cloud_lock_role_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_actions_on_cloud_lock_roles_id"
  end

  create_table "cloud_lock_role_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_activities_on_cloud_lock_roles_id"
  end

  create_table "cloud_lock_role_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_role_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_role_discussions_id"], name: "lock_role_discussions_discussions"
    t.index ["cloud_lock_roles_id"], name: "lock_role_discussions_roles"
    t.index ["users_id"], name: "index_cloud_lock_role_discussions_on_users_id"
  end

  create_table "cloud_lock_role_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_files_on_cloud_lock_roles_id"
  end

  create_table "cloud_lock_role_privileges", force: :cascade do |t|
    t.string "grant_object_name"
    t.boolean "grant_index", default: false
    t.boolean "grant_create", default: false
    t.boolean "grant_new", default: false
    t.boolean "grant_edit", default: false
    t.boolean "grant_show", default: false
    t.boolean "grant_update", default: false
    t.boolean "grant_destroy", default: false
    t.boolean "grant_options", default: false
    t.boolean "grant_default", default: false
    t.boolean "grant_empty", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_privileges_on_cloud_lock_roles_id"
  end

  create_table "cloud_lock_role_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.bigint "users_id"
    t.index ["cloud_lock_roles_id"], name: "role_subscribers"
    t.index ["users_id"], name: "lock_role_subscribers_users"
  end

  create_table "cloud_lock_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_accounts_id"
    t.index ["cloud_lock_accounts_id"], name: "index_cloud_lock_roles_on_cloud_lock_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_lock_roles_on_deleted_at"
  end

  create_table "cloud_lock_user_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_user_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_user_details", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "telephone"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_users_id"
    t.index ["cloud_lock_users_id"], name: "index_cloud_lock_user_details_on_cloud_lock_users_id"
  end

  create_table "cloud_lock_user_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_user_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_lock_users_id"
    t.index ["cloud_lock_user_discussions_id"], name: "lock_user_discussions_discussions"
    t.index ["cloud_lock_users_id"], name: "lock_user_discussions_users"
    t.index ["deleted_at"], name: "index_cloud_lock_user_discussions_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_lock_user_discussions_on_users_id"
  end

  create_table "cloud_lock_user_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_users", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_accounts_id"
    t.index ["cloud_lock_accounts_id"], name: "index_cloud_lock_users_on_cloud_lock_accounts_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_settings_on_accounts_id"
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
  add_foreign_key "cloud_lock_accounts", "accounts", column: "id"
  add_foreign_key "cloud_lock_role_actions", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_activities", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_discussions", "cloud_lock_role_discussions", column: "cloud_lock_role_discussions_id"
  add_foreign_key "cloud_lock_role_discussions", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_discussions", "users", column: "users_id"
  add_foreign_key "cloud_lock_role_files", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_privileges", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_subscribers", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_role_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_lock_roles", "cloud_lock_accounts", column: "cloud_lock_accounts_id"
  add_foreign_key "cloud_lock_user_details", "cloud_lock_users", column: "cloud_lock_users_id"
  add_foreign_key "cloud_lock_user_discussions", "cloud_lock_user_discussions", column: "cloud_lock_user_discussions_id"
  add_foreign_key "cloud_lock_user_discussions", "cloud_lock_users", column: "cloud_lock_users_id"
  add_foreign_key "cloud_lock_user_discussions", "users", column: "users_id"
  add_foreign_key "cloud_lock_users", "cloud_lock_accounts", column: "cloud_lock_accounts_id"
  add_foreign_key "settings", "accounts", column: "accounts_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
