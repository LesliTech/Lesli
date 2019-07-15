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

ActiveRecord::Schema.define(version: 2019_07_15_182840) do

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

  create_table "cloud_panel_account_contact_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "account_contact_details_accounts"
  end

  create_table "cloud_panel_account_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_account_details_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_accounts", force: :cascade do |t|
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_cloud_panel_accounts_on_accounts_id"
    t.index ["id", "accounts_id"], name: "index_cloud_panel_accounts_on_id_and_accounts_id", unique: true
  end

  create_table "cloud_panel_catalog_currencies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalogs_id"
    t.index ["cloud_panel_catalogs_id"], name: "index_cloud_panel_catalog_currencies_on_cloud_panel_catalogs_id"
  end

  create_table "cloud_panel_catalog_location_cities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalog_location_states_id"
    t.index ["cloud_panel_catalog_location_states_id"], name: "catalog_location_cities_states"
  end

  create_table "cloud_panel_catalog_location_continents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalogs_id"
    t.index ["cloud_panel_catalogs_id"], name: "catalog_location_continents_catalogs"
  end

  create_table "cloud_panel_catalog_location_countries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalog_location_continents_id"
    t.index ["cloud_panel_catalog_location_continents_id"], name: "catalog_location_countries_continents"
  end

  create_table "cloud_panel_catalog_location_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalog_location_countries_id"
    t.index ["cloud_panel_catalog_location_countries_id"], name: "catalog_location_states_countries"
  end

  create_table "cloud_panel_catalog_user_role_privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_catalog_user_roles_id"
    t.index ["cloud_panel_catalog_user_roles_id"], name: "catalog_user_role_privileges_user_roles"
  end

  create_table "cloud_panel_catalog_user_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_catalog_user_roles_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_catalogs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_catalogs_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_panel_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_panel_actions_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_panel_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_panel_activities_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_panel_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_panel_attachments_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_panel_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_panel_comments_on_cloud_panel_accounts_id"
  end

  create_table "cloud_panel_user_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_actions_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_activities_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_attachments_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_comments_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_details_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_privileges_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_user_settings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_users_id"
    t.index ["cloud_panel_users_id"], name: "index_cloud_panel_user_settings_on_cloud_panel_users_id"
  end

  create_table "cloud_panel_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_panel_accounts_id"
    t.index ["cloud_panel_accounts_id"], name: "index_cloud_panel_users_on_cloud_panel_accounts_id"
  end

  create_table "cloud_team_accounts", force: :cascade do |t|
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_cloud_team_accounts_on_accounts_id"
    t.index ["id", "accounts_id"], name: "index_cloud_team_accounts_on_id_and_accounts_id", unique: true
  end

  create_table "cloud_team_attendance_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_attendance_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_attendance_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_attendance_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_attendance_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_attendances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contract_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contract_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contract_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contract_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contract_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_contracts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_employee_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_actions_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_activities_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_attachment_employees"
  end

  create_table "cloud_team_employee_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_comments_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_contact_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_details_employees"
  end

  create_table "cloud_team_employee_contact_emergency_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_emergency_details_employees"
  end

  create_table "cloud_team_employee_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_details_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_social_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_social_account_employees"
  end

  create_table "cloud_team_employees", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_employees_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_onboarding_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_onboarding_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_onboarding_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_onboarding_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_onboarding_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_onboardings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performance_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performance_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performance_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performance_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performance_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_performances", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruiting_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruiting_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruiting_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruiting_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruiting_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_recruitings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_succession_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_succession_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_succession_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_succession_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_succession_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_successions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_team_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_team_actions_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_team_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_team_activities_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_team_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_team_attachments_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_team_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_team_comments_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_team_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_team_locations_on_cloud_team_accounts_id"
  end

  create_table "cloud_team_trainning_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_trainning_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_trainning_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_trainning_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_trainning_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_trainnings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacation_actions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacation_activities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacation_attachments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacation_comments", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacation_details", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cloud_team_vacations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
  add_foreign_key "cloud_panel_account_contact_details", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_account_details", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_accounts", "accounts", column: "accounts_id"
  add_foreign_key "cloud_panel_catalog_currencies", "cloud_panel_catalogs", column: "cloud_panel_catalogs_id"
  add_foreign_key "cloud_panel_catalog_location_cities", "cloud_panel_catalog_location_states", column: "cloud_panel_catalog_location_states_id"
  add_foreign_key "cloud_panel_catalog_location_continents", "cloud_panel_catalogs", column: "cloud_panel_catalogs_id"
  add_foreign_key "cloud_panel_catalog_location_countries", "cloud_panel_catalog_location_continents", column: "cloud_panel_catalog_location_continents_id"
  add_foreign_key "cloud_panel_catalog_location_states", "cloud_panel_catalog_location_countries", column: "cloud_panel_catalog_location_countries_id"
  add_foreign_key "cloud_panel_catalog_user_role_privileges", "cloud_panel_catalog_user_roles", column: "cloud_panel_catalog_user_roles_id"
  add_foreign_key "cloud_panel_catalog_user_roles", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_catalogs", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_panel_actions", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_panel_activities", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_panel_attachments", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_panel_comments", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_panel_user_actions", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_activities", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_attachments", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_comments", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_details", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_privileges", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_user_settings", "cloud_panel_users", column: "cloud_panel_users_id"
  add_foreign_key "cloud_panel_users", "cloud_panel_accounts", column: "cloud_panel_accounts_id"
  add_foreign_key "cloud_team_accounts", "accounts", column: "accounts_id"
  add_foreign_key "cloud_team_employee_actions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_activities", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_attachments", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_comments", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_emergency_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_social_accounts", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employees", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_team_actions", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_team_activities", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_team_attachments", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_team_comments", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_team_locations", "cloud_team_accounts", column: "cloud_team_accounts_id"
end
