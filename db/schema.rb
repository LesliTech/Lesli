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

ActiveRecord::Schema.define(version: 2020_09_29_174448) do

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
    t.integer "calling_code"
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
    t.string "module_type"
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
    t.string "nl"
    t.datetime "last_update_nl"
    t.string "pl"
    t.datetime "last_update_pl"
    t.string "pt"
    t.datetime "last_update_pt"
    t.string "it"
    t.datetime "last_update_it"
    t.string "tr"
    t.datetime "last_update_tr"
    t.string "ro"
    t.datetime "last_update_ro"
    t.string "bg"
    t.datetime "last_update_bg"
    t.datetime "last_update_priority"
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
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.string "attachment_local"
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
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_events_id"
    t.string "attachment_local"
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
    t.boolean "initial"
    t.boolean "to_be_deleted"
    t.boolean "completed_successfully"
    t.boolean "completed_unsuccessfully"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_workflows_id"
    t.string "status_type", default: "normal"
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

  create_table "cloud_focus_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_focus_accounts_on_deleted_at"
  end

  create_table "cloud_focus_custom_validation_fields", force: :cascade do |t|
    t.string "model_to_validate"
    t.string "column_to_validate"
    t.boolean "enabled"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_custom_validation_rules_id"
    t.index ["cloud_focus_custom_validation_rules_id"], name: "cloud_focus_custom_validation_rules_fields"
  end

  create_table "cloud_focus_custom_validation_rules", force: :cascade do |t|
    t.boolean "rule_required"
    t.decimal "rule_min_length"
    t.decimal "rule_max_length"
    t.string "rule_min_length_error_msg"
    t.string "rule_max_length_error_msg"
    t.string "rule_required_error_msg"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_custom_validations_id"
    t.index ["cloud_focus_custom_validations_id"], name: "cloud_focus_custom_validations_validation_rules"
  end

  create_table "cloud_focus_custom_validations", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_focus_accounts_id"
    t.index ["cloud_focus_accounts_id"], name: "cloud_focus_accounts_custom_validations"
    t.index ["users_id"], name: "index_cloud_focus_custom_validations_on_users_id"
  end

  create_table "cloud_focus_task_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "focus_task_actions_tasks"
    t.index ["users_id"], name: "index_cloud_focus_task_actions_on_users_id"
  end

  create_table "cloud_focus_task_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "index_cloud_focus_task_activities_on_cloud_focus_tasks_id"
  end

  create_table "cloud_focus_task_custom_fields", force: :cascade do |t|
    t.text "custom_field_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "focus_task_custom_fields_tasks"
  end

  create_table "cloud_focus_task_details", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "deadline"
    t.integer "importance"
    t.string "task_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "index_cloud_focus_task_details_on_cloud_focus_tasks_id"
    t.index ["deleted_at"], name: "index_cloud_focus_task_details_on_deleted_at"
  end

  create_table "cloud_focus_task_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_focus_task_discussions_id"
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_task_discussions_id"], name: "focus_task_discussions_task_discussions"
    t.index ["cloud_focus_tasks_id"], name: "focus_task_discussions_tasks"
    t.index ["users_id"], name: "index_cloud_focus_task_discussions_on_users_id"
  end

  create_table "cloud_focus_task_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_focus_tasks_id"
    t.string "attachment_local"
    t.index ["cloud_focus_tasks_id"], name: "index_cloud_focus_task_files_on_cloud_focus_tasks_id"
    t.index ["users_id"], name: "index_cloud_focus_task_files_on_users_id"
  end

  create_table "cloud_focus_task_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "focus_task_subscribers_tasks"
    t.index ["users_id"], name: "focus_task_subscribers_users"
  end

  create_table "cloud_focus_tasks", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_focus_workflow_statuses_id"
    t.string "model_type"
    t.bigint "model_id"
    t.index ["cloud_focus_accounts_id"], name: "index_cloud_focus_tasks_on_cloud_focus_accounts_id"
    t.index ["cloud_focus_workflow_statuses_id"], name: "focus_tasks_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_focus_tasks_on_deleted_at"
    t.index ["model_type", "model_id"], name: "index_cloud_focus_tasks_on_model_type_and_model_id"
    t.index ["users_id"], name: "focus_tasks_users_creator"
  end

  create_table "cloud_focus_workflow_actions", force: :cascade do |t|
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
    t.bigint "cloud_focus_workflows_id"
    t.index ["cloud_focus_workflows_id"], name: "focus_workflow_actions_workflows"
  end

  create_table "cloud_focus_workflow_associations", force: :cascade do |t|
    t.string "workflow_for"
    t.boolean "global"
    t.datetime "deleted_at"
    t.string "task_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_workflows_id"
    t.index ["cloud_focus_workflows_id"], name: "focus_workflow_associations_workflows"
  end

  create_table "cloud_focus_workflow_statuses", force: :cascade do |t|
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
    t.bigint "cloud_focus_workflows_id"
    t.string "status_type", default: "normal"
    t.index ["cloud_focus_workflows_id"], name: "focus_workflow_statuses_workflows"
  end

  create_table "cloud_focus_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "deletion_protection"
    t.boolean "default"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_accounts_id"
    t.index ["cloud_focus_accounts_id"], name: "focus_workflows_accounts"
  end

  create_table "cloud_house_accounts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_cloud_house_accounts_on_deleted_at"
  end

  create_table "cloud_house_catalog_business_services", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_business_services_accounts"
    t.index ["deleted_at"], name: "index_cloud_house_catalog_business_services_on_deleted_at"
  end

  create_table "cloud_house_catalog_company_categories", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "level", default: 0
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_company_categories_accounts"
    t.index ["deleted_at"], name: "index_cloud_house_catalog_company_categories_on_deleted_at"
  end

  create_table "cloud_house_catalog_project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_project_types_accounts"
    t.index ["deleted_at"], name: "index_cloud_house_catalog_project_types_on_deleted_at"
  end

  create_table "cloud_house_companies", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.bigint "location_city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_catalog_company_categories_id"
    t.bigint "cloud_house_catalog_business_services_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_companies_on_cloud_house_accounts_id"
    t.index ["cloud_house_catalog_business_services_id"], name: "house_companies_catalog_business_services"
    t.index ["cloud_house_catalog_company_categories_id"], name: "house_companies_catalog_company_categories"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_companies_on_cloud_house_companies_id"
    t.index ["cloud_house_employees_id"], name: "house_companies_employees"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_companies_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_companies_on_deleted_at"
    t.index ["users_id"], name: "house_companies_users"
  end

  create_table "cloud_house_company_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_actions_companies"
    t.index ["users_id"], name: "index_cloud_house_company_actions_on_users_id"
  end

  create_table "cloud_house_company_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_activities_companies"
    t.index ["field_name"], name: "index_cloud_house_company_activities_on_field_name"
  end

  create_table "cloud_house_company_associates", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_employee_services_id"
    t.index ["cloud_house_companies_id"], name: "house_company_associates_companies"
    t.index ["cloud_house_employee_services_id"], name: "house_company_associates_employee_services"
    t.index ["deleted_at"], name: "index_cloud_house_company_associates_on_deleted_at"
  end

  create_table "cloud_house_company_custom_fields", force: :cascade do |t|
    t.text "custom_field_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_custom_fields_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_company_custom_fields_contacts"
    t.index ["cloud_house_custom_fields_id"], name: "house_company_custom_fields"
    t.index ["users_id"], name: "index_cloud_house_company_custom_fields_on_users_id"
  end

  create_table "cloud_house_company_departments", force: :cascade do |t|
    t.string "street_number"
    t.string "street_other"
    t.string "street_name"
    t.string "postcode"
    t.string "name"
    t.decimal "longitude"
    t.decimal "latitude"
    t.integer "role"
    t.bigint "location_city_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_departments_companies"
    t.index ["deleted_at"], name: "index_cloud_house_company_departments_on_deleted_at"
  end

  create_table "cloud_house_company_details", force: :cascade do |t|
    t.string "name"
    t.string "contact_function"
    t.string "contact_information"
    t.string "legal_form"
    t.string "email"
    t.string "phone"
    t.string "fax"
    t.string "brokerage"
    t.text "observation"
    t.text "rating"
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "website"
    t.boolean "ivd_member"
    t.boolean "bvfi_member"
    t.string "franchise"
    t.string "region"
    t.datetime "founded_at"
    t.text "description"
    t.decimal "latitude"
    t.decimal "longitude"
    t.string "cooperation_agreement"
    t.string "contracting_partner"
    t.datetime "cooperation_agreement_start"
    t.datetime "cooperation_agreement_end"
    t.datetime "distributor_since"
    t.datetime "cooperation_limited_to"
    t.string "market_region_designed"
    t.string "commission_rate"
    t.string "agreement_specification"
    t.boolean "premium_partner", default: false
    t.boolean "specific_agreement", default: false
    t.boolean "avv_shipped", default: false
    t.boolean "avv_completed", default: false
    t.string "advertising_cost"
    t.string "event_contribution"
    t.string "advertising_contribution"
    t.text "individual_regulation_specification"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_company_details_on_cloud_house_companies_id"
    t.index ["deleted_at"], name: "index_cloud_house_company_details_on_deleted_at"
  end

  create_table "cloud_house_company_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_company_discussions_id"
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_discussions_company"
    t.index ["cloud_house_company_discussions_id"], name: "house_company_discussions_discussions"
    t.index ["users_id"], name: "house_company_discussions_users"
  end

  create_table "cloud_house_company_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_companies_id"
    t.string "attachment_local"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_company_files_on_cloud_house_companies_id"
    t.index ["users_id"], name: "index_cloud_house_company_files_on_users_id"
  end

  create_table "cloud_house_company_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_subscribers_contacts"
    t.index ["users_id"], name: "house_company_subscribers_users"
  end

  create_table "cloud_house_contact_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_actions_contacts"
    t.index ["users_id"], name: "index_cloud_house_contact_actions_on_users_id"
  end

  create_table "cloud_house_contact_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_activities_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_custom_fields", force: :cascade do |t|
    t.text "custom_field_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_custom_fields_contacts"
  end

  create_table "cloud_house_contact_details", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.datetime "birthdate"
    t.string "birthplace"
    t.string "nationality"
    t.string "email"
    t.string "telephone"
    t.string "mobile_number"
    t.string "fax_number"
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "skype"
    t.string "title"
    t.string "occupation"
    t.string "children"
    t.string "marital_status"
    t.string "signature"
    t.string "homepage"
    t.datetime "verified_at"
    t.integer "verified_by_id"
    t.string "verification_document_type"
    t.string "verification_document_number"
    t.string "verification_document_authority"
    t.boolean "deceased"
    t.datetime "death_date"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_details_on_cloud_house_contacts_id"
    t.index ["deleted_at"], name: "index_cloud_house_contact_details_on_deleted_at"
  end

  create_table "cloud_house_contact_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contact_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contact_discussions_id"], name: "house_contact_discussions_discussions"
    t.index ["cloud_house_contacts_id"], name: "house_contact_discussions_contacts"
    t.index ["users_id"], name: "index_cloud_house_contact_discussions_on_users_id"
  end

  create_table "cloud_house_contact_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.string "attachment_local"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_files_on_cloud_house_contacts_id"
    t.index ["users_id"], name: "index_cloud_house_contact_files_on_users_id"
  end

  create_table "cloud_house_contact_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_subscribers_contacts"
    t.index ["users_id"], name: "house_contact_subscribers_users"
  end

  create_table "cloud_house_contacts", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.bigint "location_city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_contacts_on_cloud_house_accounts_id"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_contacts_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_contacts_on_deleted_at"
    t.index ["users_id"], name: "house_contacts_users"
  end

  create_table "cloud_house_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "cloud_house_accounts_custom_fields"
  end

  create_table "cloud_house_custom_validation_fields", force: :cascade do |t|
    t.string "model_to_validate"
    t.string "column_to_validate"
    t.boolean "enabled"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_custom_validations_id"
    t.index ["cloud_house_custom_validations_id"], name: "cloud_house_custom_validation_fields_validations"
    t.index ["users_id"], name: "index_cloud_house_custom_validation_fields_on_users_id"
  end

  create_table "cloud_house_custom_validation_rules", force: :cascade do |t|
    t.boolean "rule_required"
    t.decimal "rule_min_length"
    t.decimal "rule_max_length"
    t.string "rule_min_length_error_msg"
    t.string "rule_max_length_error_msg"
    t.string "rule_required_error_msg"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_custom_validations_id"
    t.index ["cloud_house_custom_validations_id"], name: "house_custom_validation_rules_validations"
    t.index ["users_id"], name: "index_cloud_house_custom_validation_rules_on_users_id"
  end

  create_table "cloud_house_custom_validations", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "enabled"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_custom_validations_accounts"
    t.index ["users_id"], name: "index_cloud_house_custom_validations_on_users_id"
  end

  create_table "cloud_house_employee_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_actions_employees"
    t.index ["users_id"], name: "index_cloud_house_employee_actions_on_users_id"
  end

  create_table "cloud_house_employee_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_activities_employees"
  end

  create_table "cloud_house_employee_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_custom_fields_employees"
    t.index ["users_id"], name: "index_cloud_house_employee_custom_fields_on_users_id"
  end

  create_table "cloud_house_employee_details", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.datetime "birthdate"
    t.string "birthplace"
    t.string "nationality"
    t.string "email"
    t.string "telephone"
    t.string "mobile_number"
    t.string "fax_number"
    t.string "title"
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "occupation"
    t.string "children"
    t.string "marital_status"
    t.string "signature"
    t.string "homepage"
    t.string "position"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "index_cloud_house_employee_details_on_cloud_house_employees_id"
    t.index ["deleted_at"], name: "index_cloud_house_employee_details_on_deleted_at"
  end

  create_table "cloud_house_employee_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employee_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employee_discussions_id"], name: "house_employee_discussions_discussions"
    t.index ["cloud_house_employees_id"], name: "house_employee_discussions_employees"
    t.index ["users_id"], name: "house_employee_discussions_users"
  end

  create_table "cloud_house_employee_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_employees_id"
    t.string "attachment_local"
    t.index ["cloud_house_employees_id"], name: "index_cloud_house_employee_files_on_cloud_house_employees_id"
    t.index ["users_id"], name: "index_cloud_house_employee_files_on_users_id"
  end

  create_table "cloud_house_employee_services", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.bigint "cloud_house_catalog_business_services_id"
    t.index ["cloud_house_catalog_business_services_id"], name: "house_employee_services_catalog_business_services"
    t.index ["cloud_house_employees_id"], name: "house_employee_services_employees"
    t.index ["deleted_at"], name: "index_cloud_house_employee_services_on_deleted_at"
  end

  create_table "cloud_house_employee_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.bigint "users_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_subscribers_employees"
    t.index ["users_id"], name: "house_employee_subscribers_users"
  end

  create_table "cloud_house_employees", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.bigint "location_city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_employees_on_cloud_house_accounts_id"
    t.index ["cloud_house_companies_id"], name: "house_eomployees_companies"
    t.index ["cloud_house_employees_id"], name: "house_employees_employees"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_employees_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_employees_on_deleted_at"
    t.index ["users_id"], name: "house_employees_users"
  end

  create_table "cloud_house_lead_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "house_lead_actions_leads"
    t.index ["users_id"], name: "index_cloud_house_lead_actions_on_users_id"
  end

  create_table "cloud_house_lead_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "index_cloud_house_lead_activities_on_cloud_house_leads_id"
    t.index ["field_name"], name: "index_cloud_house_lead_activities_on_field_name"
  end

  create_table "cloud_house_lead_contacts", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.datetime "birthdate"
    t.string "birthplace"
    t.string "nationality"
    t.string "email"
    t.string "telephone"
    t.string "mobile_number"
    t.string "fax_number"
    t.integer "role"
    t.string "location_city_name"
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "skype"
    t.string "title"
    t.string "occupation"
    t.string "children"
    t.string "marital_status"
    t.integer "age"
    t.string "signature"
    t.string "homepage"
    t.boolean "deceased"
    t.datetime "death_date"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "house_lead_contacts_leads"
    t.index ["deleted_at"], name: "index_cloud_house_lead_contacts_on_deleted_at"
  end

  create_table "cloud_house_lead_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "house_custom_fields_leads_leads"
    t.index ["users_id"], name: "index_cloud_house_lead_custom_fields_on_users_id"
  end

  create_table "cloud_house_lead_details", force: :cascade do |t|
    t.text "concern"
    t.string "channel"
    t.string "status"
    t.integer "source"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "index_cloud_house_lead_details_on_cloud_house_leads_id"
    t.index ["deleted_at"], name: "index_cloud_house_lead_details_on_deleted_at"
  end

  create_table "cloud_house_lead_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_lead_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_lead_discussions_id"], name: "house_lead_discussions_discussions"
    t.index ["cloud_house_leads_id"], name: "house_lead_discussions_leads"
    t.index ["users_id"], name: "house_lead_discussions_users"
  end

  create_table "cloud_house_lead_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attachment_local"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "index_cloud_house_lead_files_on_cloud_house_leads_id"
    t.index ["users_id"], name: "index_cloud_house_lead_files_on_users_id"
  end

  create_table "cloud_house_lead_marketing_informations", force: :cascade do |t|
    t.string "origin"
    t.string "goal"
    t.text "acquisition_comment"
    t.string "questionnaire_type"
    t.datetime "questionnaire_receipt_date"
    t.boolean "testimony"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "house_eads_marketing_informations_leads"
    t.index ["deleted_at"], name: "index_cloud_house_lead_marketing_informations_on_deleted_at"
  end

  create_table "cloud_house_lead_properties", force: :cascade do |t|
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "latitude"
    t.string "longitude"
    t.string "location_city_name"
    t.string "location_state_name"
    t.string "real_state_type"
    t.string "residential_units"
    t.string "basement_or_cellar"
    t.string "general_status"
    t.string "heater_renovation"
    t.string "cables_renovation"
    t.string "windows_renovation"
    t.string "baths_renovation"
    t.string "thermal_insulation_renovation"
    t.string "top_roof_renovation"
    t.string "insurance_damage_last_years"
    t.boolean "requires_repairs"
    t.string "repairs_description"
    t.float "repairs_cost"
    t.string "heating_type"
    t.string "heating_type_construction_year"
    t.boolean "has_photovoltaic"
    t.string "photovoltaic_construction_year"
    t.float "photovoltaic_value"
    t.string "residential_location"
    t.string "area_description"
    t.string "construction_year"
    t.integer "resident_since"
    t.integer "property_valuation_form"
    t.float "property_value"
    t.boolean "has_leases"
    t.datetime "leases_running_time"
    t.float "monthly_leasehold"
    t.string "district_court"
    t.string "land_register_volume"
    t.string "land_register_of"
    t.string "land_register_sheet"
    t.string "hall"
    t.string "parcel"
    t.string "owner"
    t.float "mortages_or_land_charges"
    t.float "plot_size"
    t.text "observations"
    t.boolean "has_third_party_special_rights"
    t.string "third_party_special_rights_details"
    t.boolean "has_security_assignment"
    t.string "security_assignment_details"
    t.boolean "has_monumental_protection"
    t.string "monumental_protection_details"
    t.float "living_own_use_area"
    t.float "living_rental_use_area"
    t.float "living_rental_m2_value"
    t.float "living_rental_total_value"
    t.float "commercial_own_use_area"
    t.float "commercial_rental_use_area"
    t.float "commercial_rental_m2_value"
    t.float "commercial_rental_total_value"
    t.integer "garages_number"
    t.float "garages_rent_value"
    t.integer "parking_lots_number"
    t.float "parking_lots_rent_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.index ["cloud_house_leads_id"], name: "house_leads_properties_leads"
    t.index ["deleted_at"], name: "index_cloud_house_lead_properties_on_deleted_at"
  end

  create_table "cloud_house_lead_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_leads_id"
    t.bigint "users_id"
    t.index ["cloud_house_leads_id"], name: "house_lead_subscribers_leads"
    t.index ["users_id"], name: "house_lead_subscribers_users"
  end

  create_table "cloud_house_leads", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "cloud_house_leads_house_accounts"
    t.index ["deleted_at"], name: "index_cloud_house_leads_on_deleted_at"
    t.index ["users_id"], name: "index_cloud_house_leads_on_users_id"
  end

  create_table "cloud_house_project_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_actions_projects"
    t.index ["users_id"], name: "index_cloud_house_project_actions_on_users_id"
  end

  create_table "cloud_house_project_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_activities_on_cloud_house_projects_id"
    t.index ["field_name"], name: "index_cloud_house_project_activities_on_field_name"
  end

  create_table "cloud_house_project_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_custom_fields_projects_projects"
    t.index ["users_id"], name: "index_cloud_house_project_custom_fields_on_users_id"
  end

  create_table "cloud_house_project_customers", force: :cascade do |t|
    t.integer "role"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_project_customers_contacts"
    t.index ["cloud_house_projects_id"], name: "house_project_customers_projects"
    t.index ["deleted_at"], name: "index_cloud_house_project_customers_on_deleted_at"
  end

  create_table "cloud_house_project_details", force: :cascade do |t|
    t.bigint "code"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_details_projects"
    t.index ["code"], name: "index_cloud_house_project_details_on_code"
    t.index ["deleted_at"], name: "index_cloud_house_project_details_on_deleted_at"
  end

  create_table "cloud_house_project_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_project_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_project_discussions_id"], name: "house_project_discussions_discussions"
    t.index ["cloud_house_projects_id"], name: "house_project_discussions_projects"
    t.index ["users_id"], name: "house_project_discussions_users"
  end

  create_table "cloud_house_project_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_projects_id"
    t.string "attachment_local"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_files_on_cloud_house_projects_id"
    t.index ["users_id"], name: "index_cloud_house_project_files_on_users_id"
  end

  create_table "cloud_house_project_marketing_informations", force: :cascade do |t|
    t.string "origin"
    t.string "goal"
    t.text "acquisition_comment"
    t.string "questionnaire_type"
    t.datetime "questionnaire_receipt_date"
    t.boolean "testimony"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_marketing_informations_projects"
    t.index ["deleted_at"], name: "index_cloud_house_project_marketing_informations_on_deleted_at"
  end

  create_table "cloud_house_project_offer_reports", force: :cascade do |t|
    t.string "description"
    t.string "additional_information"
    t.string "offer_type"
    t.datetime "offer_review_start"
    t.datetime "offer_review_end"
    t.time "offer_review_time"
    t.float "offer_value"
    t.datetime "offer_valuation_date"
    t.string "offer_status"
    t.string "additional_client_calculation"
    t.boolean "commission_checked"
    t.bigint "reviewer_employee_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_offer_reports_projects"
    t.index ["deleted_at"], name: "index_cloud_house_project_offer_reports_on_deleted_at"
  end

  create_table "cloud_house_project_onboardings", force: :cascade do |t|
    t.integer "contract_folder_number"
    t.decimal "contract_property_value"
    t.decimal "contract_living_space_area"
    t.decimal "contract_value_per_area"
    t.decimal "contract_one_time_payment_value"
    t.datetime "contract_one_time_payment_date"
    t.decimal "contract_life_annuity_value"
    t.datetime "contact_first_annuity_date"
    t.string "guarantee_period_years"
    t.datetime "end_of_guarantee_period"
    t.datetime "contract_conclusion_date"
    t.datetime "land_register_entry_date"
    t.datetime "benefit_and_charges_change_date"
    t.string "benefit_and_burden_condition"
    t.decimal "selling_price"
    t.datetime "selling_date"
    t.boolean "close_to_big_cities"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_onboardings_projects"
    t.index ["deleted_at"], name: "index_cloud_house_project_onboardings_on_deleted_at"
  end

  create_table "cloud_house_project_services", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_employee_services_id"
    t.index ["cloud_house_employee_services_id"], name: "house_project_services_employee_services"
    t.index ["cloud_house_projects_id"], name: "house_project_companies_projects"
    t.index ["deleted_at"], name: "index_cloud_house_project_services_on_deleted_at"
  end

  create_table "cloud_house_project_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "users_id"
    t.index ["cloud_house_projects_id"], name: "house_project_subscribers_projects"
    t.index ["users_id"], name: "house_project_subscribers_users"
  end

  create_table "cloud_house_projects", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.bigint "cloud_house_catalog_project_types_id"
    t.bigint "cloud_house_properties_id"
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_projects_on_cloud_house_accounts_id"
    t.index ["cloud_house_catalog_project_types_id"], name: "house_projects_types"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_projects_on_cloud_house_projects_id"
    t.index ["cloud_house_properties_id"], name: "house_projects_properties"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_projects_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_projects_on_deleted_at"
    t.index ["users_id"], name: "house_projects_users"
  end

  create_table "cloud_house_properties", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_main_id"
    t.bigint "location_state_id"
    t.bigint "location_city_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_properties_on_cloud_house_accounts_id"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_properties_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_properties_on_deleted_at"
    t.index ["users_id"], name: "house_properties_users"
  end

  create_table "cloud_house_property_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_actions_properties"
    t.index ["users_id"], name: "index_cloud_house_property_actions_on_users_id"
  end

  create_table "cloud_house_property_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_activities_properties"
  end

  create_table "cloud_house_property_annuities", force: :cascade do |t|
    t.string "monthly_annuity_value"
    t.string "adjust_of_life_annuity_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_annuities_properties"
    t.index ["deleted_at"], name: "index_cloud_house_property_annuities_on_deleted_at"
  end

  create_table "cloud_house_property_binding_validations", force: :cascade do |t|
    t.float "purchase_value"
    t.float "pension_value"
    t.float "one_time_payment_value"
    t.text "one_time_payment_usage"
    t.float "monthly_pension_value"
    t.float "free_rent_value"
    t.float "yearly_value"
    t.float "property_factor"
    t.string "dlg_comment"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_binding_validations_properties"
    t.index ["deleted_at"], name: "index_cloud_house_property_binding_validations_on_deleted_at"
  end

  create_table "cloud_house_property_custom_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_label"
    t.string "field_type"
    t.string "field_instructions"
    t.string "field_placeholder"
    t.boolean "required"
    t.string "value_default"
    t.json "value_allowed"
    t.string "value_format"
    t.boolean "value_multiple"
    t.integer "value_length"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_custom_fields_properties"
    t.index ["users_id"], name: "index_cloud_house_property_custom_fields_on_users_id"
  end

  create_table "cloud_house_property_details", force: :cascade do |t|
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "latitude"
    t.string "longitude"
    t.string "real_state_type"
    t.string "residential_units"
    t.string "basement_or_cellar"
    t.string "general_status"
    t.string "heater_renovation"
    t.string "cables_renovation"
    t.string "windows_renovation"
    t.string "baths_renovation"
    t.string "thermal_insulation_renovation"
    t.string "top_roof_renovation"
    t.string "insurance_damage_last_years"
    t.boolean "requires_repairs"
    t.string "repairs_description"
    t.float "repairs_cost"
    t.string "heating_type"
    t.string "heating_type_construction_year"
    t.boolean "has_photovoltaic"
    t.string "photovoltaic_construction_year"
    t.float "photovoltaic_value"
    t.string "residential_location"
    t.string "area_description"
    t.string "construction_year"
    t.integer "resident_since"
    t.integer "property_valuation_form"
    t.float "property_value"
    t.boolean "has_leases"
    t.datetime "leases_running_time"
    t.float "monthly_leasehold"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_details_on_cloud_house_properties_id"
    t.index ["deleted_at"], name: "index_cloud_house_property_details_on_deleted_at"
  end

  create_table "cloud_house_property_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_property_discussions_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_discussions_properties"
    t.index ["cloud_house_property_discussions_id"], name: "house_property_discussions_discussions"
    t.index ["users_id"], name: "index_cloud_house_property_discussions_on_users_id"
  end

  create_table "cloud_house_property_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.string "attachment_local"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_files_on_cloud_house_properties_id"
    t.index ["users_id"], name: "index_cloud_house_property_files_on_users_id"
  end

  create_table "cloud_house_property_registers", force: :cascade do |t|
    t.string "district_court"
    t.string "land_register_volume"
    t.string "land_register_of"
    t.string "land_register_sheet"
    t.string "hall"
    t.string "parcel"
    t.string "owner"
    t.float "mortages_or_land_charges"
    t.float "plot_size"
    t.text "observations"
    t.boolean "has_third_party_special_rights"
    t.string "third_party_special_rights_details"
    t.boolean "has_security_assignment"
    t.string "security_assignment_details"
    t.boolean "has_monumental_protection"
    t.string "monumental_protection_details"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_registers_properties"
    t.index ["deleted_at"], name: "index_cloud_house_property_registers_on_deleted_at"
  end

  create_table "cloud_house_property_subscribers", force: :cascade do |t|
    t.string "action"
    t.string "notification_type"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_subscribers_properties"
    t.index ["users_id"], name: "house_property_subscribers_users"
  end

  create_table "cloud_house_property_uses", force: :cascade do |t|
    t.float "living_own_use_area"
    t.float "living_rental_use_area"
    t.float "living_rental_m2_value"
    t.float "living_rental_total_value"
    t.float "commercial_own_use_area"
    t.float "commercial_rental_use_area"
    t.float "commercial_rental_m2_value"
    t.float "commercial_rental_total_value"
    t.integer "garages_number"
    t.float "garages_rent_value"
    t.integer "parking_lots_number"
    t.float "parking_lots_rent_value"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_uses_on_cloud_house_properties_id"
    t.index ["deleted_at"], name: "index_cloud_house_property_uses_on_deleted_at"
  end

  create_table "cloud_house_property_validations", force: :cascade do |t|
    t.float "internal_price"
    t.float "expert_price"
    t.string "kop_comment"
    t.string "kop_method"
    t.float "pension_value"
    t.float "one_time_payment_value"
    t.text "one_time_payment_usage"
    t.float "monthly_pension_value"
    t.float "free_rent_value"
    t.float "yearly_value"
    t.float "property_factor"
    t.string "dlg_comment"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_validations_properties"
    t.index ["deleted_at"], name: "index_cloud_house_property_validations_on_deleted_at"
  end

  create_table "cloud_house_workflow_actions", force: :cascade do |t|
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
    t.bigint "cloud_house_workflows_id"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_actions_workflows"
  end

  create_table "cloud_house_workflow_associations", force: :cascade do |t|
    t.string "workflow_for"
    t.boolean "global"
    t.datetime "deleted_at"
    t.bigint "project_type"
    t.bigint "business_service"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflows_id"
    t.index ["business_service"], name: "house_workflow_associations_bussiness_services"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_associations_workflows"
    t.index ["project_type"], name: "house_workflow_associations_project_types"
  end

  create_table "cloud_house_workflow_statuses", force: :cascade do |t|
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
    t.bigint "cloud_house_workflows_id"
    t.string "status_type", default: "normal"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_statuses_workflows"
  end

  create_table "cloud_house_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "deletion_protection"
    t.boolean "default"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_workflows_accounts"
  end

  create_table "deutsche_leibrenten_external_leads", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "street_name"
    t.string "street_number"
    t.string "postcode"
    t.string "city_name"
    t.string "telephone"
    t.string "email"
    t.text "concern"
    t.string "channel"
    t.string "status"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "deutsche_leibrenten_external_leads_house_accounts"
    t.index ["deleted_at"], name: "index_deutsche_leibrenten_external_leads_on_deleted_at"
    t.index ["users_id"], name: "index_deutsche_leibrenten_external_leads_on_users_id"
  end

  create_table "deutsche_leibrenten_kop_request_orders", force: :cascade do |t|
    t.text "encoded_order"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "deutsche_leibrenten_kop_request_orders_house_accounts"
    t.index ["deleted_at"], name: "index_deutsche_leibrenten_kop_request_orders_on_deleted_at"
    t.index ["users_id"], name: "index_deutsche_leibrenten_kop_request_orders_on_users_id"
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
    t.string "session_uuid"
    t.string "request_controller"
    t.string "request_method"
    t.string "request_action"
    t.string "request_url"
    t.json "params"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.index ["users_id"], name: "index_user_requests_on_users_id"
  end

  create_table "user_sessions", force: :cascade do |t|
    t.string "user_remote"
    t.string "user_agent"
    t.string "user_uuid"
    t.string "session_uuid"
    t.string "session_token"
    t.string "session_source"
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
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
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
  add_foreign_key "cloud_focus_accounts", "accounts", column: "id"
  add_foreign_key "cloud_focus_custom_validation_fields", "cloud_focus_custom_validation_rules", column: "cloud_focus_custom_validation_rules_id"
  add_foreign_key "cloud_focus_custom_validation_rules", "cloud_focus_custom_validations", column: "cloud_focus_custom_validations_id"
  add_foreign_key "cloud_focus_custom_validations", "cloud_focus_accounts", column: "cloud_focus_accounts_id"
  add_foreign_key "cloud_focus_custom_validations", "users", column: "users_id"
  add_foreign_key "cloud_focus_task_actions", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_actions", "users", column: "users_id"
  add_foreign_key "cloud_focus_task_activities", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_custom_fields", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_details", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_discussions", "cloud_focus_task_discussions", column: "cloud_focus_task_discussions_id"
  add_foreign_key "cloud_focus_task_discussions", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_discussions", "users", column: "users_id"
  add_foreign_key "cloud_focus_task_files", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_files", "users", column: "users_id"
  add_foreign_key "cloud_focus_task_subscribers", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_task_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_focus_tasks", "cloud_focus_accounts", column: "cloud_focus_accounts_id"
  add_foreign_key "cloud_focus_tasks", "cloud_focus_workflow_statuses", column: "cloud_focus_workflow_statuses_id"
  add_foreign_key "cloud_focus_tasks", "users", column: "user_main_id"
  add_foreign_key "cloud_focus_tasks", "users", column: "users_id"
  add_foreign_key "cloud_focus_workflow_actions", "cloud_focus_workflow_statuses", column: "final_status_id"
  add_foreign_key "cloud_focus_workflow_actions", "cloud_focus_workflow_statuses", column: "initial_status_id"
  add_foreign_key "cloud_focus_workflow_actions", "cloud_focus_workflows", column: "cloud_focus_workflows_id"
  add_foreign_key "cloud_focus_workflow_associations", "cloud_focus_workflows", column: "cloud_focus_workflows_id"
  add_foreign_key "cloud_focus_workflow_statuses", "cloud_focus_workflows", column: "cloud_focus_workflows_id"
  add_foreign_key "cloud_focus_workflows", "cloud_focus_accounts", column: "cloud_focus_accounts_id"
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_catalog_business_services", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_company_categories", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_project_types", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "account_locations", column: "location_city_id"
  add_foreign_key "cloud_house_companies", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "cloud_house_catalog_business_services", column: "cloud_house_catalog_business_services_id"
  add_foreign_key "cloud_house_companies", "cloud_house_catalog_company_categories", column: "cloud_house_catalog_company_categories_id"
  add_foreign_key "cloud_house_companies", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_companies", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_companies", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_companies", "users", column: "user_main_id"
  add_foreign_key "cloud_house_companies", "users", column: "users_id"
  add_foreign_key "cloud_house_company_actions", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_company_activities", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_company_associates", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_associates", "cloud_house_employee_services", column: "cloud_house_employee_services_id"
  add_foreign_key "cloud_house_company_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_company_custom_fields", "cloud_house_custom_fields", column: "cloud_house_custom_fields_id"
  add_foreign_key "cloud_house_company_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_company_departments", "account_locations", column: "location_city_id"
  add_foreign_key "cloud_house_company_departments", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_details", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_discussions", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_discussions", "cloud_house_company_discussions", column: "cloud_house_company_discussions_id"
  add_foreign_key "cloud_house_company_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_company_files", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_files", "users", column: "users_id"
  add_foreign_key "cloud_house_company_subscribers", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_actions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_activities", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_details", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contact_discussions", column: "cloud_house_contact_discussions_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_files", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_files", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_subscribers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contacts", "account_locations", column: "location_city_id"
  add_foreign_key "cloud_house_contacts", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_contacts", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_contacts", "users", column: "user_main_id"
  add_foreign_key "cloud_house_contacts", "users", column: "users_id"
  add_foreign_key "cloud_house_custom_fields", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_custom_validation_fields", "cloud_house_custom_validations", column: "cloud_house_custom_validations_id"
  add_foreign_key "cloud_house_custom_validation_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_custom_validation_rules", "cloud_house_custom_validations", column: "cloud_house_custom_validations_id"
  add_foreign_key "cloud_house_custom_validation_rules", "users", column: "users_id"
  add_foreign_key "cloud_house_custom_validations", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_custom_validations", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_actions", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_activities", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_custom_fields", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_details", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_discussions", "cloud_house_employee_discussions", column: "cloud_house_employee_discussions_id"
  add_foreign_key "cloud_house_employee_discussions", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_files", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_files", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_services", "cloud_house_catalog_business_services", column: "cloud_house_catalog_business_services_id"
  add_foreign_key "cloud_house_employee_services", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_subscribers", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_employees", "account_locations", column: "location_city_id"
  add_foreign_key "cloud_house_employees", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_employees", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_employees", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employees", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_employees", "users", column: "user_main_id"
  add_foreign_key "cloud_house_employees", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_actions", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_activities", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_contacts", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_custom_fields", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_details", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_discussions", "cloud_house_lead_discussions", column: "cloud_house_lead_discussions_id"
  add_foreign_key "cloud_house_lead_discussions", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_files", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_files", "users", column: "users_id"
  add_foreign_key "cloud_house_lead_marketing_informations", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_properties", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_subscribers", "cloud_house_leads", column: "cloud_house_leads_id"
  add_foreign_key "cloud_house_lead_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_leads", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_leads", "users", column: "users_id"
  add_foreign_key "cloud_house_project_actions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_project_activities", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_project_custom_fields", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_project_discussions", column: "cloud_house_project_discussions_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_project_files", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_files", "users", column: "users_id"
  add_foreign_key "cloud_house_project_marketing_informations", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_offer_reports", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_offer_reports", "users", column: "reviewer_employee_id"
  add_foreign_key "cloud_house_project_onboardings", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_employee_services", column: "cloud_house_employee_services_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_projects", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_projects", "cloud_house_catalog_project_types", column: "cloud_house_catalog_project_types_id"
  add_foreign_key "cloud_house_projects", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_projects", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_projects", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_projects", "users", column: "user_main_id"
  add_foreign_key "cloud_house_projects", "users", column: "users_id"
  add_foreign_key "cloud_house_properties", "account_locations", column: "location_city_id"
  add_foreign_key "cloud_house_properties", "account_locations", column: "location_state_id"
  add_foreign_key "cloud_house_properties", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_properties", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_properties", "users", column: "user_main_id"
  add_foreign_key "cloud_house_properties", "users", column: "users_id"
  add_foreign_key "cloud_house_property_actions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_actions", "users", column: "users_id"
  add_foreign_key "cloud_house_property_activities", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_activities", "users", column: "users_id"
  add_foreign_key "cloud_house_property_annuities", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_binding_validations", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_fields", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_property_details", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_property_discussions", column: "cloud_house_property_discussions_id"
  add_foreign_key "cloud_house_property_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_property_files", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_files", "users", column: "users_id"
  add_foreign_key "cloud_house_property_registers", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_property_uses", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_validations", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_workflow_actions", "cloud_house_workflow_statuses", column: "final_status_id"
  add_foreign_key "cloud_house_workflow_actions", "cloud_house_workflow_statuses", column: "initial_status_id"
  add_foreign_key "cloud_house_workflow_actions", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_associations", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_statuses", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "deutsche_leibrenten_external_leads", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "deutsche_leibrenten_external_leads", "users", column: "users_id"
  add_foreign_key "deutsche_leibrenten_kop_request_orders", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "deutsche_leibrenten_kop_request_orders", "users", column: "users_id"
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
  add_foreign_key "user_activities", "users", column: "owner_id"
  add_foreign_key "user_activities", "users", column: "users_id"
  add_foreign_key "user_details", "users", column: "users_id"
  add_foreign_key "user_logs", "users", column: "users_id"
  add_foreign_key "user_requests", "users", column: "users_id"
  add_foreign_key "user_sessions", "users", column: "users_id"
  add_foreign_key "user_settings", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "roles", column: "roles_id"
end
