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

ActiveRecord::Schema.define(version: 3011108) do

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

  create_table "cloud_driver_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_driver_accounts_on_deleted_at"
  end

  create_table "cloud_driver_calendar_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_actions_calendars"
  end

  create_table "cloud_driver_calendar_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_activities_calendars"
  end

  create_table "cloud_driver_calendar_details", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "100,100,200"
    t.boolean "default", default: false
    t.boolean "active", default: true
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_details_calendars"
    t.index ["deleted_at"], name: "index_cloud_driver_calendar_details_on_deleted_at"
  end

  create_table "cloud_driver_calendar_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendar_discussions_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendar_discussions_id"], name: "calendar_discussions"
    t.index ["cloud_driver_calendars_id"], name: "driver_calendar_discussions"
    t.index ["users_id"], name: "index_cloud_driver_calendar_discussions_on_users_id"
  end

  create_table "cloud_driver_calendar_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_calendar_files_on_cloud_driver_calendars_id"
    t.index ["users_id"], name: "index_cloud_driver_calendar_files_on_users_id"
  end

  create_table "cloud_driver_calendar_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "driver_calendar_subscribers_calendars"
    t.index ["users_id"], name: "driver_calendar_subscribers_users"
  end

  create_table "cloud_driver_calendars", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_accounts_id"
    t.bigint "cloud_driver_workflow_statuses_id"
    t.index ["cloud_driver_accounts_id"], name: "index_cloud_driver_calendars_on_cloud_driver_accounts_id"
    t.index ["cloud_driver_workflow_statuses_id"], name: "driver_calendars_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_driver_calendars_on_deleted_at"
  end

  create_table "cloud_driver_event_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_actions_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_activities_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_attendants", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.bigint "users_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_attendants_on_cloud_driver_events_id"
    t.index ["deleted_at"], name: "index_cloud_driver_event_attendants_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_driver_event_attendants_on_users_id"
  end

  create_table "cloud_driver_event_details", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "event_date"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string "location"
    t.string "url"
    t.string "event_type"
    t.boolean "public"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_details_on_cloud_driver_events_id"
    t.index ["deleted_at"], name: "index_cloud_driver_event_details_on_deleted_at"
  end

  create_table "cloud_driver_event_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_event_discussions_id"
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_event_discussions_id"], name: "event_discussions"
    t.index ["cloud_driver_events_id"], name: "driver_event_discussions"
    t.index ["users_id"], name: "index_cloud_driver_event_discussions_on_users_id"
  end

  create_table "cloud_driver_event_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_files_on_cloud_driver_events_id"
    t.index ["users_id"], name: "index_cloud_driver_event_files_on_users_id"
  end

  create_table "cloud_driver_event_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "driver_event_subscribers_events"
    t.index ["users_id"], name: "driver_event_subscribers_users"
  end

  create_table "cloud_driver_events", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_workflow_statuses_id"
    t.bigint "cloud_driver_calendars_id"
    t.bigint "cloud_driver_accounts_id"
    t.string "model_type"
    t.bigint "model_id"
    t.bigint "organizer_id"
    t.index ["cloud_driver_accounts_id"], name: "index_cloud_driver_events_on_cloud_driver_accounts_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_events_on_cloud_driver_calendars_id"
    t.index ["cloud_driver_workflow_statuses_id"], name: "driver_events_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_driver_events_on_deleted_at"
    t.index ["model_type", "model_id"], name: "index_cloud_driver_events_on_model_type_and_model_id"
    t.index ["organizer_id"], name: "index_cloud_driver_events_on_organizer_id"
    t.index ["users_id"], name: "house_events_users"
  end

  create_table "cloud_driver_workflow_actions", force: :cascade do |t|
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
    t.bigint "cloud_driver_workflows_id"
    t.index ["cloud_driver_workflows_id"], name: "driver_workflow_actions_workflows"
  end

  create_table "cloud_driver_workflow_associations", force: :cascade do |t|
    t.string "workflow_for"
    t.boolean "global"
    t.datetime "deleted_at"
    t.bigint "project_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_workflows_id"
    t.index ["cloud_driver_workflows_id"], name: "driver_workflow_associations_workflows"
  end

  create_table "cloud_driver_workflow_statuses", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.string "next_statuses"
    t.boolean "initial"
    t.boolean "to_be_deleted"
    t.boolean "completed_successfully"
    t.boolean "completed_unsuccessfully"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_workflows_id"
    t.index ["cloud_driver_workflows_id"], name: "driver_workflow_statuses_workflows"
  end

  create_table "cloud_driver_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "deletion_protection"
    t.boolean "default"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_accounts_id"
    t.index ["cloud_driver_accounts_id"], name: "driver_workflows_accounts"
  end

  create_table "cloud_mailer_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_mailer_accounts_on_deleted_at"
  end

  create_table "cloud_mailer_campaign_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaign_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaign_custom_fields", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaign_details", force: :cascade do |t|
    t.integer "type"
    t.integer "sender"
    t.integer "status"
    t.integer "opens"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_mailer_campaigns_id"
    t.index ["cloud_mailer_campaigns_id"], name: "mailer_campaign_details_campaigns"
    t.index ["deleted_at"], name: "index_cloud_mailer_campaign_details_on_deleted_at"
  end

  create_table "cloud_mailer_campaign_discussions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaign_email_recipients", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "data_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_mailer_campaigns_id"
    t.index ["cloud_mailer_campaigns_id"], name: "mailer_campaign_email_recipients_campaigns"
    t.index ["deleted_at"], name: "index_cloud_mailer_campaign_email_recipients_on_deleted_at"
  end

  create_table "cloud_mailer_campaign_email_statistics", force: :cascade do |t|
    t.integer "opens"
    t.integer "clicks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_mailer_campaigns_id"
    t.index ["cloud_mailer_campaigns_id"], name: "mailer_campaign_email_statistics_campaigns"
  end

  create_table "cloud_mailer_campaign_emails", force: :cascade do |t|
    t.string "name"
    t.string "from_name"
    t.string "from_email"
    t.string "reply_email"
    t.string "subject_line"
    t.string "preview_text"
    t.json "email_body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_mailer_campaigns_id"
    t.index ["cloud_mailer_campaigns_id"], name: "index_cloud_mailer_campaign_emails_on_cloud_mailer_campaigns_id"
    t.index ["deleted_at"], name: "index_cloud_mailer_campaign_emails_on_deleted_at"
  end

  create_table "cloud_mailer_campaign_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaign_subscribers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_campaigns", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_mailer_accounts_id"
    t.index ["cloud_mailer_accounts_id"], name: "index_cloud_mailer_campaigns_on_cloud_mailer_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_mailer_campaigns_on_deleted_at"
  end

  create_table "role_details", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.boolean "grant_options", default: false
    t.boolean "grant_default", default: false
    t.boolean "grant_search", default: false
    t.boolean "grant_empty", default: false
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
    t.integer "type"
    t.string "title"
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
  add_foreign_key "cloud_driver_accounts", "accounts", column: "id"
  add_foreign_key "cloud_driver_calendar_actions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_activities", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_details", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_discussions", "cloud_driver_calendar_discussions", column: "cloud_driver_calendar_discussions_id"
  add_foreign_key "cloud_driver_calendar_discussions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_discussions", "users", column: "users_id"
  add_foreign_key "cloud_driver_calendar_files", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_files", "users", column: "users_id"
  add_foreign_key "cloud_driver_calendar_subscribers", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_driver_calendars", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_driver_calendars", "cloud_driver_workflow_statuses", column: "cloud_driver_workflow_statuses_id"
  add_foreign_key "cloud_driver_event_actions", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_activities", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_attendants", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_attendants", "users", column: "users_id"
  add_foreign_key "cloud_driver_event_details", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_discussions", "cloud_driver_event_discussions", column: "cloud_driver_event_discussions_id"
  add_foreign_key "cloud_driver_event_discussions", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_discussions", "users", column: "users_id"
  add_foreign_key "cloud_driver_event_files", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_files", "users", column: "users_id"
  add_foreign_key "cloud_driver_event_subscribers", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_workflow_statuses", column: "cloud_driver_workflow_statuses_id"
  add_foreign_key "cloud_driver_events", "users", column: "users_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflow_statuses", column: "final_status_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflow_statuses", column: "initial_status_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflow_associations", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflow_statuses", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflows", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_mailer_accounts", "accounts", column: "id"
  add_foreign_key "cloud_mailer_campaign_details", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_email_recipients", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_email_statistics", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_emails", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaigns", "cloud_mailer_accounts", column: "cloud_mailer_accounts_id"
  add_foreign_key "role_details", "roles", column: "roles_id"
  add_foreign_key "role_overrides", "users", column: "users_id"
  add_foreign_key "role_privileges", "roles", column: "roles_id"
  add_foreign_key "roles", "accounts", column: "accounts_id"
  add_foreign_key "user_activities", "users", column: "users_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "user_settings", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "roles", column: "roles_id"
end
