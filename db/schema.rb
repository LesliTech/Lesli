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

ActiveRecord::Schema.define(version: 2020_09_27_031859) do

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

  create_table "account_integrations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_main_id"
    t.bigint "users_id"
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_account_integrations_on_accounts_id"
    t.index ["users_id"], name: "index_account_integrations_on_users_id"
  end

  create_table "account_locations", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "postal_code"
    t.string "latitude"
    t.string "longitude"
    t.string "code"
    t.string "calling_code"
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

  create_table "cloud_babel_bucket_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_buckets_id"
    t.index ["cloud_babel_buckets_id"], name: "index_cloud_babel_bucket_activities_on_cloud_babel_buckets_id"
  end

  create_table "cloud_babel_bucket_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_babel_bucket_discussions_id"
    t.bigint "cloud_babel_buckets_id"
    t.index ["cloud_babel_bucket_discussions_id"], name: "babel_bucket_discussions_discussions"
    t.index ["cloud_babel_buckets_id"], name: "babel_module_discussions_buckets"
    t.index ["users_id"], name: "index_cloud_babel_bucket_discussions_on_users_id"
  end

  create_table "cloud_babel_buckets", force: :cascade do |t|
    t.string "name"
    t.string "reference_module"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_modules_id"
    t.index ["cloud_babel_modules_id"], name: "index_cloud_babel_buckets_on_cloud_babel_modules_id"
  end

  create_table "cloud_babel_module_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_modules_id"
    t.index ["cloud_babel_modules_id"], name: "index_cloud_babel_module_activities_on_cloud_babel_modules_id"
  end

  create_table "cloud_babel_module_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_babel_module_discussions_id"
    t.bigint "cloud_babel_modules_id"
    t.index ["cloud_babel_module_discussions_id"], name: "babel_module_discussions_discussions"
    t.index ["cloud_babel_modules_id"], name: "babel_module_discussions_modules"
    t.index ["users_id"], name: "index_cloud_babel_module_discussions_on_users_id"
  end

  create_table "cloud_babel_modules", force: :cascade do |t|
    t.string "name"
    t.string "platform"
    t.string "instance"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_babel_string_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.text "reference_module_bucket_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_strings_id"
    t.index ["cloud_babel_strings_id"], name: "babel_string_activities_strings"
    t.index ["reference_module_bucket_string"], name: "babel_string_activities_module_bucket_string"
  end

  create_table "cloud_babel_string_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.text "reference_module_bucket_string"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_babel_string_discussions_id"
    t.bigint "cloud_babel_strings_id"
    t.index ["cloud_babel_string_discussions_id"], name: "babel_string_discussions_discussions"
    t.index ["cloud_babel_strings_id"], name: "babel_module_discussions_strings"
    t.index ["reference_module_bucket_string"], name: "babel_string_discussions_module_bucket_string"
    t.index ["users_id"], name: "index_cloud_babel_string_discussions_on_users_id"
  end

  create_table "cloud_babel_strings", force: :cascade do |t|
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
    t.string "status"
    t.string "context"
    t.string "priority"
    t.boolean "need_help"
    t.boolean "need_translation"
    t.datetime "last_update_status"
    t.datetime "last_update_context"
    t.datetime "last_update_priority"
    t.datetime "last_update_need_help"
    t.datetime "last_update_need_translation"
    t.string "reference_module_bucket"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_babel_buckets_id"
    t.index ["cloud_babel_buckets_id"], name: "index_cloud_babel_strings_on_cloud_babel_buckets_id"
    t.index ["users_id"], name: "index_cloud_babel_strings_on_users_id"
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

  create_table "cloud_dispatcher_accounts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "driver_calendar_actions_calendars"
    t.index ["users_id"], name: "index_cloud_driver_calendar_actions_on_users_id"
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
    t.index ["cloud_driver_calendar_discussions_id"], name: "driver_calendar_discussions_calendar_discussions"
    t.index ["cloud_driver_calendars_id"], name: "driver_calendar_discussions_calendars"
    t.index ["users_id"], name: "index_cloud_driver_calendar_discussions_on_users_id"
  end

  create_table "cloud_driver_calendar_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attachment_local"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_calendar_files_on_cloud_driver_calendars_id"
    t.index ["users_id"], name: "index_cloud_driver_calendar_files_on_users_id"
  end

  create_table "cloud_driver_calendar_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
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
    t.bigint "user_main_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_driver_workflow_statuses_id"
    t.index ["cloud_driver_accounts_id"], name: "index_cloud_driver_calendars_on_cloud_driver_accounts_id"
    t.index ["cloud_driver_workflow_statuses_id"], name: "driver_calendars_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_driver_calendars_on_deleted_at"
    t.index ["users_id"], name: "driver_calendars_users"
  end

  create_table "cloud_driver_event_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "driver_event_actions_events"
    t.index ["users_id"], name: "index_cloud_driver_event_actions_on_users_id"
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
    t.index ["cloud_driver_event_discussions_id"], name: "driver_event_discussions_event_discussions"
    t.index ["cloud_driver_events_id"], name: "driver_event_discussions_events"
    t.index ["users_id"], name: "index_cloud_driver_event_discussions_on_users_id"
  end

  create_table "cloud_driver_event_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attachment_local"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_files_on_cloud_driver_events_id"
    t.index ["users_id"], name: "index_cloud_driver_event_files_on_users_id"
  end

  create_table "cloud_driver_event_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
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
    t.bigint "user_main_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_driver_workflow_statuses_id"
    t.bigint "cloud_driver_calendars_id"
    t.string "model_type"
    t.bigint "model_id"
    t.index ["cloud_driver_accounts_id"], name: "index_cloud_driver_events_on_cloud_driver_accounts_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_events_on_cloud_driver_calendars_id"
    t.index ["cloud_driver_workflow_statuses_id"], name: "driver_events_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_driver_events_on_deleted_at"
    t.index ["model_type", "model_id"], name: "index_cloud_driver_events_on_model_type_and_model_id"
    t.index ["users_id"], name: "driver_events_users"
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
    t.string "status_type"
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

  create_table "cloud_mailer_audience_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_audience_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_audience_contacts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_mailer_audiences_id"
    t.index ["cloud_mailer_audiences_id"], name: "mailer_audience_contacts_audiences"
    t.index ["deleted_at"], name: "index_cloud_mailer_audience_contacts_on_deleted_at"
  end

  create_table "cloud_mailer_audience_details", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_mailer_audiences_id"
    t.index ["cloud_mailer_audiences_id"], name: "mailer_audience_details_audiences"
    t.index ["deleted_at"], name: "index_cloud_mailer_audience_details_on_deleted_at"
  end

  create_table "cloud_mailer_audience_discussions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_audience_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_audience_subscribers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_mailer_audiences", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "cloud_mailer_accounts_id"
    t.index ["cloud_mailer_accounts_id"], name: "index_cloud_mailer_audiences_on_cloud_mailer_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_mailer_audiences_on_deleted_at"
    t.index ["user_id"], name: "index_cloud_mailer_audiences_on_user_id"
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
    t.string "name"
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
    t.bigint "cloud_mailer_audiences_id"
    t.bigint "user_id"
    t.bigint "cloud_mailer_accounts_id"
    t.index ["cloud_mailer_accounts_id"], name: "index_cloud_mailer_campaigns_on_cloud_mailer_accounts_id"
    t.index ["cloud_mailer_audiences_id"], name: "index_cloud_mailer_campaigns_on_cloud_mailer_audiences_id"
    t.index ["deleted_at"], name: "index_cloud_mailer_campaigns_on_deleted_at"
    t.index ["user_id"], name: "index_cloud_mailer_campaigns_on_user_id"
  end

  create_table "cloud_notes_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_notes_accounts_on_deleted_at"
  end

  create_table "cloud_notes_dashboards", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_note_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_note_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_note_details", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.string "privacy"
    t.jsonb "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_notes_notes_id"
    t.index ["cloud_notes_notes_id"], name: "index_cloud_notes_note_details_on_cloud_notes_notes_id"
  end

  create_table "cloud_notes_note_discussions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_note_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_note_subscribers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebook_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebook_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebook_details", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_notes_notebooks_id"
    t.index ["cloud_notes_notebooks_id"], name: "index_cloud_notes_notebook_details_on_cloud_notes_notebooks_id"
  end

  create_table "cloud_notes_notebook_discussions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebook_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebook_subscribers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_notes_notebooks", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "cloud_notes_accounts_id"
    t.index ["cloud_notes_accounts_id"], name: "index_cloud_notes_notebooks_on_cloud_notes_accounts_id"
    t.index ["deleted_at"], name: "index_cloud_notes_notebooks_on_deleted_at"
    t.index ["user_id"], name: "index_cloud_notes_notebooks_on_user_id"
  end

  create_table "cloud_notes_notes", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "cloud_notes_accounts_id"
    t.bigint "cloud_notes_notebooks_id"
    t.index ["cloud_notes_accounts_id"], name: "index_cloud_notes_notes_on_cloud_notes_accounts_id"
    t.index ["cloud_notes_notebooks_id"], name: "index_cloud_notes_notes_on_cloud_notes_notebooks_id"
    t.index ["user_id"], name: "index_cloud_notes_notes_on_user_id"
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
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "user_logs", force: :cascade do |t|
    t.string "session_uuid"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_user_logs_on_users_id"
  end

  create_table "user_requests", force: :cascade do |t|
    t.string "request_agent"
    t.string "request_controller"
    t.string "request_method"
    t.string "request_action"
    t.string "request_url"
    t.json "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "user_sessions_id"
    t.index ["user_sessions_id"], name: "index_user_requests_on_user_sessions_id"
    t.index ["users_id"], name: "index_user_requests_on_users_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.string "user_remote"
    t.string "user_agent"
    t.string "user_uuid"
    t.string "session_uuid"
    t.string "session_token"
    t.string "session_source"
    t.integer "usage_count"
    t.datetime "last_used_at"
    t.datetime "expiration_at"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["deleted_at"], name: "index_user_sessions_on_deleted_at"
    t.index ["expiration_at"], name: "index_user_sessions_on_expiration_at"
    t.index ["users_id"], name: "index_user_sessions_on_users_id"
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
    t.string "category"
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
  add_foreign_key "account_integrations", "accounts", column: "accounts_id"
  add_foreign_key "account_integrations", "users", column: "user_main_id"
  add_foreign_key "account_integrations", "users", column: "users_id"
  add_foreign_key "account_locations", "account_locations", column: "parent_id"
  add_foreign_key "account_locations", "accounts", column: "accounts_id"
  add_foreign_key "account_settings", "accounts", column: "accounts_id"
  add_foreign_key "accounts", "users", column: "users_id"
  add_foreign_key "cloud_babel_bucket_activities", "cloud_babel_buckets", column: "cloud_babel_buckets_id"
  add_foreign_key "cloud_babel_bucket_discussions", "cloud_babel_bucket_discussions", column: "cloud_babel_bucket_discussions_id"
  add_foreign_key "cloud_babel_bucket_discussions", "cloud_babel_buckets", column: "cloud_babel_buckets_id"
  add_foreign_key "cloud_babel_bucket_discussions", "users", column: "users_id"
  add_foreign_key "cloud_babel_buckets", "cloud_babel_modules", column: "cloud_babel_modules_id"
  add_foreign_key "cloud_babel_module_activities", "cloud_babel_modules", column: "cloud_babel_modules_id"
  add_foreign_key "cloud_babel_module_discussions", "cloud_babel_module_discussions", column: "cloud_babel_module_discussions_id"
  add_foreign_key "cloud_babel_module_discussions", "cloud_babel_modules", column: "cloud_babel_modules_id"
  add_foreign_key "cloud_babel_module_discussions", "users", column: "users_id"
  add_foreign_key "cloud_babel_string_activities", "cloud_babel_strings", column: "cloud_babel_strings_id"
  add_foreign_key "cloud_babel_string_discussions", "cloud_babel_string_discussions", column: "cloud_babel_string_discussions_id"
  add_foreign_key "cloud_babel_string_discussions", "cloud_babel_strings", column: "cloud_babel_strings_id"
  add_foreign_key "cloud_babel_string_discussions", "users", column: "users_id"
  add_foreign_key "cloud_babel_strings", "cloud_babel_buckets", column: "cloud_babel_buckets_id"
  add_foreign_key "cloud_babel_strings", "users", column: "users_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
  add_foreign_key "cloud_driver_accounts", "accounts", column: "id"
  add_foreign_key "cloud_driver_calendar_actions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_actions", "users", column: "users_id"
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
  add_foreign_key "cloud_driver_calendars", "users", column: "user_main_id"
  add_foreign_key "cloud_driver_calendars", "users", column: "users_id"
  add_foreign_key "cloud_driver_event_actions", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_actions", "users", column: "users_id"
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
  add_foreign_key "cloud_driver_events", "users", column: "user_main_id"
  add_foreign_key "cloud_driver_events", "users", column: "users_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflow_statuses", column: "final_status_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflow_statuses", column: "initial_status_id"
  add_foreign_key "cloud_driver_workflow_actions", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflow_associations", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflow_statuses", "cloud_driver_workflows", column: "cloud_driver_workflows_id"
  add_foreign_key "cloud_driver_workflows", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_mailer_accounts", "accounts", column: "id"
  add_foreign_key "cloud_mailer_audience_contacts", "cloud_mailer_audiences", column: "cloud_mailer_audiences_id"
  add_foreign_key "cloud_mailer_audience_details", "cloud_mailer_audiences", column: "cloud_mailer_audiences_id"
  add_foreign_key "cloud_mailer_audiences", "cloud_mailer_accounts", column: "cloud_mailer_accounts_id"
  add_foreign_key "cloud_mailer_audiences", "users"
  add_foreign_key "cloud_mailer_campaign_details", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_email_recipients", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_email_statistics", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaign_emails", "cloud_mailer_campaigns", column: "cloud_mailer_campaigns_id"
  add_foreign_key "cloud_mailer_campaigns", "cloud_mailer_accounts", column: "cloud_mailer_accounts_id"
  add_foreign_key "cloud_mailer_campaigns", "cloud_mailer_audiences", column: "cloud_mailer_audiences_id"
  add_foreign_key "cloud_mailer_campaigns", "users"
  add_foreign_key "cloud_notes_accounts", "accounts", column: "id"
  add_foreign_key "cloud_notes_note_details", "cloud_notes_notes", column: "cloud_notes_notes_id"
  add_foreign_key "cloud_notes_notebook_details", "cloud_notes_notebooks", column: "cloud_notes_notebooks_id"
  add_foreign_key "cloud_notes_notebooks", "cloud_notes_accounts", column: "cloud_notes_accounts_id"
  add_foreign_key "cloud_notes_notebooks", "users"
  add_foreign_key "cloud_notes_notes", "cloud_notes_accounts", column: "cloud_notes_accounts_id"
  add_foreign_key "cloud_notes_notes", "cloud_notes_notebooks", column: "cloud_notes_notebooks_id"
  add_foreign_key "cloud_notes_notes", "users"
  add_foreign_key "role_details", "roles", column: "roles_id"
  add_foreign_key "role_overrides", "users", column: "users_id"
  add_foreign_key "role_privilege_defaults", "roles", column: "roles_id"
  add_foreign_key "role_privileges", "roles", column: "roles_id"
  add_foreign_key "roles", "accounts", column: "accounts_id"
  add_foreign_key "template_documents", "templates", column: "templates_id"
  add_foreign_key "template_documents", "users", column: "users_id"
  add_foreign_key "template_mappings", "template_documents", column: "template_documents_id"
  add_foreign_key "template_mappings", "template_variables", column: "template_variables_id"
  add_foreign_key "template_variables", "templates", column: "templates_id"
  add_foreign_key "template_variables", "users", column: "users_id"
  add_foreign_key "templates", "accounts", column: "accounts_id"
  add_foreign_key "user_activities", "users", column: "owner_id"
  add_foreign_key "user_activities", "users", column: "users_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "user_logs", "users", column: "users_id"
  add_foreign_key "user_requests", "user_sessions", column: "user_sessions_id"
  add_foreign_key "user_requests", "users", column: "users_id"
  add_foreign_key "user_sessions", "users", column: "users_id"
  add_foreign_key "user_settings", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "roles", column: "roles_id"
end
