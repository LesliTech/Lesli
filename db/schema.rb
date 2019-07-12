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

ActiveRecord::Schema.define(version: 2019_07_12_170738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "users_id"
    t.bigint "account_plans_id"
    t.index ["account_plans_id"], name: "index_accounts_on_account_plans_id"
    t.index ["users_id"], name: "index_accounts_on_users_id"
  end

  create_table "cloud_panel_account_details", force: :cascade do |t|
    t.string "company_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_account_details_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_account_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_panel_catalog_user_roles_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_account_users_on_cloud_panel_accounts_id"
    t.index ["cloud_panel_catalog_user_roles_id"], name: "panel_account_users-catalog_user_roles"
    t.index ["users_id"], name: "index_cloud_panel_account_users_on_users_id"
  end

  create_table "cloud_panel_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_cloud_panel_accounts_on_accounts_id"
  end

  create_table "cloud_panel_catalog_currencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_catalog_currencies_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_catalog_user_role_privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalog_user_roles_id"
    t.index ["cloud_panel_catalog_user_roles_id"], name: "panel_catalog_user_role_privileges-user_roles"
  end

  create_table "cloud_panel_catalog_user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_catalog_user_roles_on_cloud_panel_accounts_id"
  end

  create_table "cloud_team_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_cloud_team_accounts_on_accounts_id"
  end

  create_table "cloud_team_employee_contact_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_details-team_employees"
  end

  create_table "cloud_team_employee_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_details_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_employees_on_cloud_team_accounts_id"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "account_plans", column: "account_plans_id"
  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "cloud_panel_account_details", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_account_users", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_account_users", "cloud_panel_catalog_user_roles", column: "cloud_panel_catalog_user_roles_id"
  add_foreign_key "cloud_panel_account_users", "users", column: "users_id"
  add_foreign_key "cloud_panel_accounts", "accounts", column: "accounts_id"
  add_foreign_key "cloud_panel_catalog_currencies", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_catalog_user_role_privileges", "cloud_panel_catalog_user_roles", column: "cloud_panel_catalog_user_roles_id"
  add_foreign_key "cloud_panel_catalog_user_roles", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_team_accounts", "accounts", column: "accounts_id"
  add_foreign_key "cloud_team_employee_contact_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employees", "cloud_team_accounts", column: "cloud_team_accounts_id"
end
