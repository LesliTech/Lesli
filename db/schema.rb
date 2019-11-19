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

ActiveRecord::Schema.define(version: 304) do

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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "bells_id"
    t.index ["bells_id"], name: "index_bell_notifications_on_bells_id"
  end

  create_table "bells", force: :cascade do |t|
  end

  create_table "lock_user_details", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_lock_user_details_on_users_id"
  end

  create_table "lock_user_privileges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_lock_user_privileges_on_users_id"
  end

  create_table "lock_user_role_privileges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "lock_user_roles_id"
    t.index ["lock_user_roles_id"], name: "index_lock_user_role_privileges_on_lock_user_roles_id"
  end

  create_table "lock_user_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "locks_id"
    t.index ["locks_id"], name: "index_lock_user_roles_on_locks_id"
  end

  create_table "locks", force: :cascade do |t|
  end

  create_table "settings", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "bell_emails", "bells", column: "bells_id"
  add_foreign_key "bell_messages", "bells", column: "bells_id"
  add_foreign_key "bell_notifications", "bells", column: "bells_id"
  add_foreign_key "bells", "accounts", column: "id"
  add_foreign_key "lock_user_details", "users", column: "users_id"
  add_foreign_key "lock_user_privileges", "users", column: "users_id"
  add_foreign_key "lock_user_role_privileges", "lock_user_roles", column: "lock_user_roles_id"
  add_foreign_key "lock_user_roles", "locks", column: "locks_id"
  add_foreign_key "locks", "accounts", column: "id"
  add_foreign_key "settings", "accounts", column: "id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
