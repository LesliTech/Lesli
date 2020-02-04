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

  create_table "cloud_help_accounts", force: :cascade do |t|
  end

  create_table "cloud_help_slas", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.integer "expected_response_time"
    t.integer "expected_resolution_time"
    t.text "provider_repercussions"
    t.text "exceptions"
    t.boolean "default", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_slas_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_actions_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_activities_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_assignments", force: :cascade do |t|
    t.bigint "team_id"
    t.integer "assignation_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.bigint "users_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_assignments_on_cloud_help_tickets_id"
    t.index ["users_id"], name: "index_cloud_help_ticket_assignments_on_users_id"
  end

  create_table "cloud_help_ticket_categories", force: :cascade do |t|
    t.string "name"
    t.string "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["ancestry"], name: "index_cloud_help_ticket_categories_on_ancestry"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_categories_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_details", force: :cascade do |t|
    t.string "subject"
    t.text "description"
    t.datetime "deadline"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_workflow_details_id"
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_priorities_id"
    t.bigint "cloud_help_ticket_sources_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_details_categories"
    t.index ["cloud_help_ticket_priorities_id"], name: "help_ticket_details_priorities"
    t.index ["cloud_help_ticket_sources_id"], name: "help_ticket_details_sources"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_details_types"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_details_on_cloud_help_tickets_id"
    t.index ["cloud_help_workflow_details_id"], name: "help_ticket_details_workflow_details"
  end

  create_table "cloud_help_ticket_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_discussions_id"], name: "help_ticket_discussions_discussions"
    t.index ["cloud_help_tickets_id"], name: "help_ticket_discussions_tickets"
    t.index ["users_id"], name: "help_ticket_discussions_users"
  end

  create_table "cloud_help_ticket_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_files_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_priorities", force: :cascade do |t|
    t.string "name"
    t.integer "weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_priorities_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_sources", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_sources_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.bigint "users_id"
    t.index ["cloud_help_tickets_id"], name: "help_ticket_subscribers_tickets"
    t.index ["users_id"], name: "help_ticket_subscribers_users"
  end

  create_table "cloud_help_ticket_timelines", force: :cascade do |t|
    t.integer "action"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_timelines_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_types_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_workflows", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_workflows_id"
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "help_ticket_workflows_account"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_workflows_category"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_workflows_types"
    t.index ["cloud_help_workflows_id"], name: "help_ticket_workflows_workflow"
  end

  create_table "cloud_help_tickets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_tickets_on_cloud_help_accounts_id"
    t.index ["users_id"], name: "index_cloud_help_tickets_on_users_id"
  end

  create_table "cloud_help_workflow_details", force: :cascade do |t|
    t.string "next_states"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_workflows_id"
    t.bigint "cloud_help_workflow_states_id"
    t.index ["cloud_help_workflow_states_id"], name: "help_workflow_details_states"
    t.index ["cloud_help_workflows_id"], name: "help_workflow_details"
  end

  create_table "cloud_help_workflow_states", force: :cascade do |t|
    t.string "name"
    t.boolean "initial"
    t.boolean "final"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "help_workflow_states_accounts"
  end

  create_table "cloud_help_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "default"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "help_workflows_accounts"
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
    t.string "icon"
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
    t.index ["cloud_lock_role_discussions_id"], name: "role_discussions_discussions"
    t.index ["cloud_lock_roles_id"], name: "role_discussions"
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
    t.string "privilege_object_name"
    t.boolean "privilege_index", default: false
    t.boolean "privilege_create", default: false
    t.boolean "privilege_new", default: false
    t.boolean "privilege_edit", default: false
    t.boolean "privilege_show", default: false
    t.boolean "privilege_update", default: false
    t.boolean "privilege_destroy", default: false
    t.boolean "privilege_options", default: false
    t.boolean "privilege_default", default: false
    t.boolean "privilege_empty", default: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_privileges_on_cloud_lock_roles_id"
    t.index ["deleted_at"], name: "index_cloud_lock_role_privileges_on_deleted_at"
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
    t.bigint "users_id"
    t.index ["cloud_lock_accounts_id"], name: "index_cloud_lock_roles_on_cloud_lock_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_lock_roles_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_lock_roles_on_users_id"
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
    t.bigint "users_id"
    t.index ["users_id"], name: "index_cloud_lock_user_details_on_users_id"
  end

  create_table "cloud_lock_user_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_cloud_lock_user_discussions_on_deleted_at"
  end

  create_table "cloud_lock_user_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_user_followers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_team_accounts", force: :cascade do |t|
  end

  create_table "cloud_team_attendance_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_attendance_actions_on_cloud_team_employees_id"
  end

  create_table "cloud_team_attendance_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_attendances_id"
    t.index ["cloud_team_attendances_id"], name: "team_attendance_activities_employees"
  end

  create_table "cloud_team_attendance_details", force: :cascade do |t|
    t.string "description"
    t.json "tag"
    t.datetime "start"
    t.datetime "end"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_attendances_id"
    t.index ["cloud_team_attendances_id"], name: "team_attendance_details_attendances"
  end

  create_table "cloud_team_attendance_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_attendance_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_team_attendances_id"
    t.index ["cloud_team_attendance_discussions_id"], name: "team_attendance_discussions"
    t.index ["cloud_team_attendances_id"], name: "team_attendances"
    t.index ["users_id"], name: "index_cloud_team_attendance_discussions_on_users_id"
  end

  create_table "cloud_team_attendance_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_attendances_id"
    t.index ["cloud_team_attendances_id"], name: "index_cloud_team_attendance_files_on_cloud_team_attendances_id"
  end

  create_table "cloud_team_attendance_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_attendances_id"
    t.bigint "users_id"
    t.index ["cloud_team_attendances_id"], name: "team_attendance_subscribers_attendances"
    t.index ["users_id"], name: "team_attendance_subscribers_users"
  end

  create_table "cloud_team_attendances", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_attendances_on_cloud_team_employees_id"
    t.index ["deleted_at"], name: "index_cloud_team_attendances_on_deleted_at"
  end

  create_table "cloud_team_employee_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_actions_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_activities_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_contact_details", force: :cascade do |t|
    t.string "work_telephone"
    t.string "work_mobile"
    t.string "work_email"
    t.string "work_address"
    t.string "work_location"
    t.string "personal_mobile_number"
    t.string "personal_phone_number"
    t.string "personal_email_address"
    t.string "address"
    t.string "location"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_details_employees"
    t.index ["deleted_at"], name: "index_cloud_team_employee_contact_details_on_deleted_at"
  end

  create_table "cloud_team_employee_contact_emergency_details", force: :cascade do |t|
    t.string "full_name"
    t.string "relation"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "full_address"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_emergency_details_employees"
    t.index ["deleted_at"], name: "team_employee_contact_emergency_details_deleted_at"
  end

  create_table "cloud_team_employee_details", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "third_name"
    t.string "surname"
    t.string "second_surname"
    t.string "married_name"
    t.datetime "birthdate"
    t.string "phone_number"
    t.string "mobile_number"
    t.string "fax"
    t.string "email"
    t.string "address"
    t.string "location"
    t.bigint "nationality_country_id"
    t.string "identity_document_number"
    t.string "passport_number"
    t.string "marital_status"
    t.string "gender"
    t.string "blood_group"
    t.text "biography"
    t.text "family_background"
    t.text "health_details"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_details_on_cloud_team_employees_id"
    t.index ["deleted_at"], name: "index_cloud_team_employee_details_on_deleted_at"
  end

  create_table "cloud_team_employee_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employee_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employee_discussions_id"], name: "employee_discussions_discussions"
    t.index ["cloud_team_employees_id"], name: "employee_discussions"
    t.index ["users_id"], name: "index_cloud_team_employee_discussions_on_users_id"
  end

  create_table "cloud_team_employee_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_files_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_locations", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_locations_on_cloud_team_employees_id"
    t.index ["deleted_at"], name: "index_cloud_team_employee_locations_on_deleted_at"
  end

  create_table "cloud_team_employee_social_accounts", force: :cascade do |t|
    t.string "username"
    t.integer "platform_id", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_social_account_employees"
    t.index ["deleted_at"], name: "index_cloud_team_employee_social_accounts_on_deleted_at"
  end

  create_table "cloud_team_employee_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employees_id"
    t.bigint "users_id"
    t.index ["cloud_team_employees_id"], name: "employee_subscribers"
    t.index ["users_id"], name: "team_employee_subscribers_users"
  end

  create_table "cloud_team_employees", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_accounts_id"
    t.bigint "users_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_employees_on_cloud_team_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_team_employees_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_team_employees_on_users_id"
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
    t.bigint "cloud_lock_roles_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["cloud_lock_roles_id"], name: "index_users_on_cloud_lock_roles_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_help_accounts", "accounts", column: "id"
  add_foreign_key "cloud_help_slas", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_actions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_activities", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_assignments", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_assignments", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_categories", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_priorities", column: "cloud_help_ticket_priorities_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_sources", column: "cloud_help_ticket_sources_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_workflow_details", column: "cloud_help_workflow_details_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_ticket_discussions", column: "cloud_help_ticket_discussions_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_files", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_priorities", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_sources", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_subscribers", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_timelines", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_types", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_workflows", column: "cloud_help_workflows_id"
  add_foreign_key "cloud_help_tickets", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_tickets", "users", column: "users_id"
  add_foreign_key "cloud_help_workflow_details", "cloud_help_workflow_states", column: "cloud_help_workflow_states_id"
  add_foreign_key "cloud_help_workflow_details", "cloud_help_workflows", column: "cloud_help_workflows_id"
  add_foreign_key "cloud_help_workflow_states", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_workflows", "cloud_help_accounts", column: "cloud_help_accounts_id"
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
  add_foreign_key "cloud_lock_roles", "users", column: "users_id"
  add_foreign_key "cloud_lock_user_details", "users", column: "users_id"
  add_foreign_key "cloud_team_accounts", "accounts", column: "id"
  add_foreign_key "cloud_team_attendance_actions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_attendance_activities", "cloud_team_attendances", column: "cloud_team_attendances_id"
  add_foreign_key "cloud_team_attendance_details", "cloud_team_attendances", column: "cloud_team_attendances_id"
  add_foreign_key "cloud_team_attendance_discussions", "cloud_team_attendance_discussions", column: "cloud_team_attendance_discussions_id"
  add_foreign_key "cloud_team_attendance_discussions", "cloud_team_attendances", column: "cloud_team_attendances_id"
  add_foreign_key "cloud_team_attendance_discussions", "users", column: "users_id"
  add_foreign_key "cloud_team_attendance_files", "cloud_team_attendances", column: "cloud_team_attendances_id"
  add_foreign_key "cloud_team_attendance_subscribers", "cloud_team_attendances", column: "cloud_team_attendances_id"
  add_foreign_key "cloud_team_attendance_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_team_attendances", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_actions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_activities", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_emergency_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_discussions", "cloud_team_employee_discussions", column: "cloud_team_employee_discussions_id"
  add_foreign_key "cloud_team_employee_discussions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_discussions", "users", column: "users_id"
  add_foreign_key "cloud_team_employee_files", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_locations", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_social_accounts", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_subscribers", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_team_employees", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "cloud_team_employees", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "cloud_lock_roles", column: "cloud_lock_roles_id"
end
