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

ActiveRecord::Schema.define(version: 404) do

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

  create_table "bell_emails", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bells_id"
    t.index ["bells_id"], name: "index_bell_emails_on_bells_id"
  end

  create_table "bell_messages", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bells_id"
    t.index ["bells_id"], name: "index_bell_messages_on_bells_id"
  end

  create_table "bell_notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "href"
    t.string "format"
    t.boolean "read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bells_id"
    t.bigint "users_id"
    t.index ["bells_id"], name: "index_bell_notifications_on_bells_id"
    t.index ["users_id"], name: "index_bell_notifications_on_users_id"
  end

  create_table "bells", force: :cascade do |t|
  end

  create_table "lock_role_privileges", force: :cascade do |t|
    t.string "subject"
    t.boolean "privilege_get", default: false
    t.boolean "privilege_post", default: false
    t.boolean "privilege_put", default: false
    t.boolean "privilege_delete", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "lock_roles_id"
    t.index ["lock_roles_id"], name: "index_lock_role_privileges_on_lock_roles_id"
  end

  create_table "lock_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locks_id"
    t.index ["locks_id"], name: "index_lock_roles_on_locks_id"
  end

  create_table "locks", force: :cascade do |t|
  end

  create_table "settings", force: :cascade do |t|
  end

  create_table "translation_strings", force: :cascade do |t|
    t.string "entry"
    t.string "lang_en"
    t.json "lang_en_j"
    t.string "lang_es"
    t.string "lang_de"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "translations_id"
    t.index ["translations_id"], name: "index_translation_strings_on_translations_id"
  end

  create_table "translations", force: :cascade do |t|
    t.string "file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_details", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_user_details_on_users_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bell_emails", "bells", column: "bells_id"
  add_foreign_key "bell_messages", "bells", column: "bells_id"
  add_foreign_key "bell_notifications", "bells", column: "bells_id"
  add_foreign_key "bell_notifications", "users", column: "users_id"
  add_foreign_key "bells", "accounts", column: "id"
  add_foreign_key "lock_role_privileges", "lock_roles", column: "lock_roles_id"
  add_foreign_key "lock_roles", "locks", column: "locks_id"
  add_foreign_key "locks", "accounts", column: "id"
  add_foreign_key "settings", "accounts", column: "id"
  add_foreign_key "translation_strings", "translations", column: "translations_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
