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

ActiveRecord::Schema.define(version: 10010104) do

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
    t.bigint "users_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_details_on_cloud_driver_events_id"
    t.index ["users_id"], name: "index_cloud_driver_event_details_on_users_id"
  end

  create_table "cloud_driver_events", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_events_on_cloud_driver_calendars_id"
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

  create_table "cloud_house_contact_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_actions_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_activities_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_custom_field_values", force: :cascade do |t|
    t.datetime "value_datetime"
    t.integer "value_integer"
    t.boolean "value_boolean"
    t.string "value_string"
    t.json "value_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contact_custom_fields_id"
    t.index ["cloud_house_contact_custom_fields_id"], name: "house_contact_custom_field_values_custom_fields"
  end

  create_table "cloud_house_contact_custom_fields", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_custom_fields_contacts"
    t.index ["users_id"], name: "index_cloud_house_contact_custom_fields_on_users_id"
  end

  create_table "cloud_house_contact_details", force: :cascade do |t|
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.string "birthdate"
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
    t.bigint "city_id"
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
    t.string "lead_origin"
    t.string "lead_source"
    t.string "questionnaire_type"
    t.datetime "questionnaire_received_date"
    t.boolean "testimony"
    t.text "notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_details_on_cloud_house_contacts_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "index_cloud_house_contact_files_on_cloud_house_contacts_id"
  end

  create_table "cloud_house_contact_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_subscribers_contacts"
    t.index ["users_id"], name: "house_contact_subscribers_users"
  end

  create_table "cloud_house_contacts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_contacts_on_cloud_house_accounts_id"
    t.index ["users_id"], name: "index_cloud_house_contacts_on_users_id"
  end

  create_table "cloud_house_properties", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_properties_on_cloud_house_accounts_id"
    t.index ["users_id"], name: "index_cloud_house_properties_on_users_id"
  end

  create_table "cloud_house_property_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_actions_on_cloud_house_properties_id"
  end

  create_table "cloud_house_property_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_activities_properties"
  end

  create_table "cloud_house_property_custom_field_values", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_property_custom_fields_id"
    t.index ["cloud_house_property_custom_fields_id"], name: "house_property_custom_field_values_fields"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_custom_fields_properties"
    t.index ["users_id"], name: "index_cloud_house_property_custom_fields_on_users_id"
  end

  create_table "cloud_house_property_details", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_details_on_cloud_house_properties_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_files_on_cloud_house_properties_id"
  end

  create_table "cloud_house_property_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_subscribers_properties"
    t.index ["users_id"], name: "house_property_subscribers_users"
  end

  create_table "cloud_house_workflows", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_accounts", force: :cascade do |t|
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_roles_id"
    t.index ["cloud_lock_roles_id"], name: "index_cloud_lock_role_privileges_on_cloud_lock_roles_id"
  end

  create_table "cloud_lock_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_lock_accounts_id"
    t.index ["cloud_lock_accounts_id"], name: "index_cloud_lock_roles_on_cloud_lock_accounts_id"
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
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_buckets", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_buckets", column: "cloud_babel_translation_buckets_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
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
  add_foreign_key "cloud_driver_event_details", "users", column: "users_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_catalog_business_services", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_contact_actions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_activities", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_custom_field_values", "cloud_house_contact_custom_fields", column: "cloud_house_contact_custom_fields_id"
  add_foreign_key "cloud_house_contact_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_details", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contact_discussions", column: "cloud_house_contact_discussions_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_files", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contacts", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_contacts", "users", column: "users_id"
  add_foreign_key "cloud_house_properties", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_properties", "users", column: "users_id"
  add_foreign_key "cloud_house_property_actions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_activities", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_field_values", "cloud_house_property_custom_fields", column: "cloud_house_property_custom_fields_id"
  add_foreign_key "cloud_house_property_custom_fields", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_property_details", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_property_discussions", column: "cloud_house_property_discussions_id"
  add_foreign_key "cloud_house_property_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_property_files", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_lock_accounts", "accounts", column: "id"
  add_foreign_key "cloud_lock_role_privileges", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_roles", "cloud_lock_accounts", column: "cloud_lock_accounts_id"
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
