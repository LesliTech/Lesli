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

ActiveRecord::Schema.define(version: 20031010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_activities", force: :cascade do |t|
    t.string "system_module"
    t.string "system_process"
    t.string "description"
    t.json "payload"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_account_activities_on_accounts_id"
  end

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
    t.string "module_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_babel_translation_strings", force: :cascade do |t|
    t.string "label"
    t.string "es"
    t.string "en"
    t.string "de"
    t.string "fr"
    t.string "nl"
    t.string "pl"
    t.string "pt"
    t.string "it"
    t.string "tr"
    t.string "ro"
    t.string "bg"
    t.string "status"
    t.string "context"
    t.string "priority"
    t.boolean "need_help"
    t.boolean "need_translation"
    t.string "reference_bucket"
    t.datetime "last_update_es"
    t.datetime "last_update_en"
    t.datetime "last_update_de"
    t.datetime "last_update_fr"
    t.datetime "last_update_nl"
    t.datetime "last_update_pl"
    t.datetime "last_update_pt"
    t.datetime "last_update_it"
    t.datetime "last_update_tr"
    t.datetime "last_update_ro"
    t.datetime "last_update_bg"
    t.datetime "last_update_status"
    t.datetime "last_update_context"
    t.datetime "last_update_priority"
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

  create_table "mitwerken_cloud_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_mitwerken_cloud_accounts_on_deleted_at"
  end

  create_table "mitwerken_cloud_user_sessions", force: :cascade do |t|
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mitwerken_cloud_users_id"
    t.index ["mitwerken_cloud_users_id"], name: "index_mitwerken_cloud_user_sessions_on_mitwerken_cloud_users_id"
  end

  create_table "mitwerken_cloud_users", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "mitwerken_cloud_accounts_id"
    t.index ["deleted_at"], name: "index_mitwerken_cloud_users_on_deleted_at"
    t.index ["mitwerken_cloud_accounts_id"], name: "index_mitwerken_cloud_users_on_mitwerken_cloud_accounts_id"
  end

  create_table "mitwerken_cloud_workflow_actions", force: :cascade do |t|
    t.string "name"
    t.bigint "initial_status_id"
    t.bigint "final_status_id"
    t.string "action_type"
    t.boolean "execute_immediately"
    t.string "template_path"
    t.json "input_data"
    t.json "system_data"
    t.json "concerning_users"
    t.json "configuration"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mitwerken_cloud_workflows_id"
    t.index ["mitwerken_cloud_workflows_id"], name: "mitwerken_cloud_workflow_actions_workflows"
  end

  create_table "mitwerken_cloud_workflow_associations", force: :cascade do |t|
    t.string "workflow_for"
    t.boolean "global"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mitwerken_cloud_workflows_id"
    t.index ["mitwerken_cloud_workflows_id"], name: "mitwerken_cloud_workflow_associations_workflows"
  end

  create_table "mitwerken_cloud_workflow_statuses", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "next_statuses"
    t.string "status_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mitwerken_cloud_workflows_id"
    t.index ["mitwerken_cloud_workflows_id"], name: "mitwerken_cloud_workflow_statuses_workflows"
  end

  create_table "mitwerken_cloud_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "deletion_protection"
    t.boolean "default"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "mitwerken_cloud_accounts_id"
    t.index ["mitwerken_cloud_accounts_id"], name: "mitwerken_cloud_workflows_accounts"
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
    t.boolean "grant_search", default: false
    t.boolean "grant_resources", default: false
    t.boolean "grant_options", default: false
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

  create_table "system_activities", force: :cascade do |t|
    t.string "system_module"
    t.string "system_process"
    t.json "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_system_activities_on_accounts_id"
  end

  create_table "template_documents", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "model_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "templates_id"
    t.index ["deleted_at"], name: "index_template_documents_on_deleted_at"
    t.index ["templates_id"], name: "index_template_documents_on_templates_id"
    t.index ["users_id"], name: "index_template_documents_on_users_id"
  end

  create_table "template_mappings", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "template_documents_id"
    t.bigint "template_variables_id"
    t.index ["deleted_at"], name: "index_template_mappings_on_deleted_at"
    t.index ["template_documents_id"], name: "index_template_mappings_on_template_documents_id"
    t.index ["template_variables_id"], name: "index_template_mappings_on_template_variables_id"
  end

  create_table "template_variables", force: :cascade do |t|
    t.string "name"
    t.string "field_name"
    t.string "table_name"
    t.string "table_alias"
    t.string "model_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "templates_id"
    t.index ["deleted_at"], name: "index_template_variables_on_deleted_at"
    t.index ["templates_id"], name: "index_template_variables_on_templates_id"
    t.index ["users_id"], name: "index_template_variables_on_users_id"
  end

  create_table "templates", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_templates_on_accounts_id"
    t.index ["deleted_at"], name: "index_templates_on_deleted_at"
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

  add_foreign_key "account_activities", "accounts", column: "accounts_id"
  add_foreign_key "account_locations", "account_locations", column: "parent_id"
  add_foreign_key "account_locations", "accounts", column: "accounts_id"
  add_foreign_key "account_settings", "accounts", column: "accounts_id"
  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
  add_foreign_key "mitwerken_cloud_accounts", "accounts", column: "id"
  add_foreign_key "mitwerken_cloud_user_sessions", "mitwerken_cloud_users", column: "mitwerken_cloud_users_id"
  add_foreign_key "mitwerken_cloud_users", "mitwerken_cloud_accounts", column: "mitwerken_cloud_accounts_id"
  add_foreign_key "mitwerken_cloud_users", "users", column: "id"
  add_foreign_key "mitwerken_cloud_workflow_actions", "mitwerken_cloud_workflow_statuses", column: "final_status_id"
  add_foreign_key "mitwerken_cloud_workflow_actions", "mitwerken_cloud_workflow_statuses", column: "initial_status_id"
  add_foreign_key "mitwerken_cloud_workflow_actions", "mitwerken_cloud_workflows", column: "mitwerken_cloud_workflows_id"
  add_foreign_key "mitwerken_cloud_workflow_associations", "mitwerken_cloud_workflows", column: "mitwerken_cloud_workflows_id"
  add_foreign_key "mitwerken_cloud_workflow_statuses", "mitwerken_cloud_workflows", column: "mitwerken_cloud_workflows_id"
  add_foreign_key "mitwerken_cloud_workflows", "mitwerken_cloud_accounts", column: "mitwerken_cloud_accounts_id"
  add_foreign_key "role_details", "roles", column: "roles_id"
  add_foreign_key "role_overrides", "users", column: "users_id"
  add_foreign_key "role_privilege_defaults", "roles", column: "roles_id"
  add_foreign_key "role_privileges", "roles", column: "roles_id"
  add_foreign_key "roles", "accounts", column: "accounts_id"
  add_foreign_key "system_activities", "accounts", column: "accounts_id"
  add_foreign_key "template_documents", "templates", column: "templates_id"
  add_foreign_key "template_documents", "users", column: "users_id"
  add_foreign_key "template_mappings", "template_documents", column: "template_documents_id"
  add_foreign_key "template_mappings", "template_variables", column: "template_variables_id"
  add_foreign_key "template_variables", "templates", column: "templates_id"
  add_foreign_key "template_variables", "users", column: "users_id"
  add_foreign_key "templates", "accounts", column: "accounts_id"
  add_foreign_key "user_activities", "users", column: "users_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "user_settings", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "roles", column: "roles_id"
end
