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

ActiveRecord::Schema.define(version: 2020_02_17_142005) do

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

  create_table "cloud_babel_translation_buckets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_translation_buckets_id"
    t.bigint "cloud_babel_translation_modules_id"
    t.index ["cloud_babel_translation_buckets_id"], name: "cloud_babel_translation_buckets_buckets"
    t.index ["cloud_babel_translation_modules_id"], name: "babel_translation_objects_modules"
  end

  create_table "cloud_babel_translation_modules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_babel_translation_strings", force: :cascade do |t|
    t.string "context"
    t.string "label"
    t.string "es"
    t.string "en"
    t.string "de"
    t.string "fr"
    t.integer "status"
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

  create_table "cloud_bell_accounts", force: :cascade do |t|
  end

  create_table "cloud_bell_notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "href"
    t.string "format"
    t.string "sender"
    t.boolean "read", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_bell_accounts_id"
    t.index ["cloud_bell_accounts_id"], name: "index_cloud_bell_notifications_on_cloud_bell_accounts_id"
    t.index ["users_id"], name: "index_cloud_bell_notifications_on_users_id"
  end

  create_table "cloud_driver_accounts", force: :cascade do |t|
  end

  create_table "cloud_driver_calendar_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_details_calendars"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_calendar_files_on_cloud_driver_calendars_id"
  end

  create_table "cloud_driver_calendar_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "driver_calendar_subscribers_calendars"
    t.index ["users_id"], name: "driver_calendar_subscribers_users"
  end

  create_table "cloud_driver_calendars", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_accounts_id"
    t.index ["cloud_driver_accounts_id"], name: "index_cloud_driver_calendars_on_cloud_driver_accounts_id"
  end

  create_table "cloud_driver_event_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_actions_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_activities_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_details", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string "location"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_details_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_events", force: :cascade do |t|
    t.string "reference_name"
    t.integer "reference_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_events_on_cloud_driver_calendars_id"
  end

  create_table "cloud_focus_accounts", force: :cascade do |t|
  end

  create_table "cloud_focus_dashboards", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_actions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_activities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_cutom_field_values", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_details", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "deadline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_focus_tasks_id"
    t.index ["cloud_focus_tasks_id"], name: "index_cloud_focus_task_details_on_cloud_focus_tasks_id"
  end

  create_table "cloud_focus_task_discussions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_task_subscribers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_focus_tasks", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_cloud_focus_tasks_on_accounts_id"
  end

  create_table "cloud_house_accounts", force: :cascade do |t|
  end

  create_table "cloud_house_catalog_business_services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_business_services_accounts"
  end

  create_table "cloud_house_catalog_project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_project_types_accounts"
  end

  create_table "cloud_house_dashboards", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_house_properties", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflow_details_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_properties_on_cloud_house_accounts_id"
    t.index ["cloud_house_workflow_details_id"], name: "index_cloud_house_properties_on_cloud_house_workflow_details_id"
  end

  create_table "cloud_house_property_details", force: :cascade do |t|
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "state"
    t.string "city"
    t.string "country"
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
    t.boolean "has_leases"
    t.date "leases_running_time"
    t.float "monthly_leasehold"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_details_on_cloud_house_properties_id"
  end

  create_table "cloud_house_property_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "default"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflows_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_property_workflows_accounts"
    t.index ["cloud_house_workflows_id"], name: "house_property_workflows_workflows"
  end

  create_table "cloud_house_workflow_details", force: :cascade do |t|
    t.string "next_states"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflows_id"
    t.bigint "cloud_house_workflow_states_id"
    t.index ["cloud_house_workflow_states_id"], name: "house_workflow_details_states"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_details"
  end

  create_table "cloud_house_workflow_states", force: :cascade do |t|
    t.string "name"
    t.boolean "initial"
    t.boolean "final"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_workflow_states_accounts"
  end

  create_table "cloud_house_workflows", force: :cascade do |t|
    t.string "name"
    t.boolean "default"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_workflows_accounts"
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
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
  add_foreign_key "cloud_driver_accounts", "accounts", column: "id"
  add_foreign_key "cloud_driver_calendar_actions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_activities", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_details", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_discussions", "cloud_driver_calendar_discussions", column: "cloud_driver_calendar_discussions_id"
  add_foreign_key "cloud_driver_calendar_discussions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_discussions", "users", column: "users_id"
  add_foreign_key "cloud_driver_calendar_files", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_subscribers", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_driver_calendars", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_driver_event_actions", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_activities", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_details", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_focus_accounts", "accounts", column: "id"
  add_foreign_key "cloud_focus_task_details", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_tasks", "accounts", column: "accounts_id"
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_catalog_business_services", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_project_types", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_properties", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_properties", "cloud_house_workflow_details", column: "cloud_house_workflow_details_id"
  add_foreign_key "cloud_house_property_details", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_property_workflows", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_details", "cloud_house_workflow_states", column: "cloud_house_workflow_states_id"
  add_foreign_key "cloud_house_workflow_details", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_states", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "settings", "accounts", column: "accounts_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
