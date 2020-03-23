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

ActiveRecord::Schema.define(version: 2020_03_13_165231) do

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
    t.string "attachment"
    t.string "file_type"
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
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_activities_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_attendants", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.bigint "users_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_attendants_on_cloud_driver_events_id"
    t.index ["users_id"], name: "index_cloud_driver_event_attendants_on_users_id"
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

  create_table "cloud_driver_event_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "file_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_files_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_subscriptions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "cloud_house_catalog_company_categories", force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.integer "level", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_company_categories_accounts"
  end

  create_table "cloud_house_catalog_project_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_catalog_project_types_accounts"
  end

  create_table "cloud_house_companies", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.bigint "cloud_house_catalog_company_categories_id"
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_companies_on_cloud_house_accounts_id"
    t.index ["cloud_house_catalog_company_categories_id"], name: "house_companies_catalog_company_categories"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_companies_on_cloud_house_companies_id"
    t.index ["cloud_house_employees_id"], name: "house_companies_employees"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_companies_workflow_statuses"
    t.index ["deleted_at"], name: "index_cloud_house_companies_on_deleted_at"
  end

  create_table "cloud_house_company_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_actions_companies"
  end

  create_table "cloud_house_company_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_activities_companies"
  end

  create_table "cloud_house_company_associates", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_employee_services_id"
    t.index ["cloud_house_companies_id"], name: "house_company_associates_companies"
    t.index ["cloud_house_employee_services_id"], name: "house_company_associates_employee_services"
  end

  create_table "cloud_house_company_custom_field_values", force: :cascade do |t|
    t.datetime "value_datetime"
    t.integer "value_integer"
    t.boolean "value_boolean"
    t.string "value_string"
    t.json "value_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_company_custom_fields_id"
    t.index ["cloud_house_company_custom_fields_id"], name: "house_company_custom_field_values_custom_fields"
  end

  create_table "cloud_house_company_custom_fields", force: :cascade do |t|
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
    t.index ["cloud_house_contacts_id"], name: "house_company_custom_fields_contacts"
    t.index ["users_id"], name: "index_cloud_house_company_custom_fields_on_users_id"
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
    t.string "city_name"
    t.string "website"
    t.string "ivd_member"
    t.string "bvfi_member"
    t.string "franchise"
    t.string "region"
    t.date "founded_at"
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
    t.boolean "premium_partner", default: false
    t.boolean "specific_agreement", default: false
    t.boolean "avv_shipped", default: false
    t.boolean "avv_completed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_company_details_on_cloud_house_companies_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_company_files_on_cloud_house_companies_id"
  end

  create_table "cloud_house_company_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
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
    t.string "category"
    t.bigint "users"
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
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_contact_custom_fields_contacts"
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
    t.boolean "deceased"
    t.date "death_date"
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
    t.string "attachment"
    t.string "file_type"
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
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_contacts_on_cloud_house_accounts_id"
  end

  create_table "cloud_house_employee_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "index_cloud_house_employee_actions_on_cloud_house_employees_id"
  end

  create_table "cloud_house_employee_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_activities_employees"
  end

  create_table "cloud_house_employee_custom_field_values", force: :cascade do |t|
    t.datetime "value_datetime"
    t.integer "value_integer"
    t.boolean "value_boolean"
    t.string "value_string"
    t.json "value_json"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employee_custom_fields_id"
    t.index ["cloud_house_employee_custom_fields_id"], name: "house_employee_custom_field_values_custom_fields"
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
    t.string "birthdate"
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
    t.string "city_name"
    t.string "occupation"
    t.string "children"
    t.string "marital_status"
    t.string "signature"
    t.string "homepage"
    t.string "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "index_cloud_house_employee_details_on_cloud_house_employees_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.index ["cloud_house_employees_id"], name: "index_cloud_house_employee_files_on_cloud_house_employees_id"
  end

  create_table "cloud_house_employee_services", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.bigint "cloud_house_catalog_business_services_id"
    t.index ["cloud_house_catalog_business_services_id"], name: "house_employee_services_catalog_business_services"
    t.index ["cloud_house_employees_id"], name: "house_employee_services_employees"
  end

  create_table "cloud_house_employee_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_employees_id"
    t.bigint "users_id"
    t.index ["cloud_house_employees_id"], name: "house_employee_subscribers_employees"
    t.index ["users_id"], name: "house_employee_subscribers_users"
  end

  create_table "cloud_house_employees", force: :cascade do |t|
    t.bigint "cloud_house_accounts_id"
    t.bigint "users_id"
    t.bigint "cloud_house_companies_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_employees_on_cloud_house_accounts_id"
    t.index ["cloud_house_companies_id"], name: "house_employees_companies"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_employees_workflow_statuses"
    t.index ["users_id"], name: "house_employees_users"
  end

  create_table "cloud_house_project_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_actions_on_cloud_house_projects_id"
  end

  create_table "cloud_house_project_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "users"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_activities_on_cloud_house_projects_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_custom_fields_projects_projects"
    t.index ["users_id"], name: "index_cloud_house_project_custom_fields_on_users_id"
  end

  create_table "cloud_house_project_customers", force: :cascade do |t|
    t.integer "role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_project_customers_contacts"
    t.index ["cloud_house_projects_id"], name: "house_project_customers_projects"
  end

  create_table "cloud_house_project_details", force: :cascade do |t|
    t.bigint "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_details_projects"
    t.index ["code"], name: "index_cloud_house_project_details_on_code"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_files_on_cloud_house_projects_id"
  end

  create_table "cloud_house_project_marketing_informations", force: :cascade do |t|
    t.string "origin"
    t.string "goal"
    t.text "acquisition_comment"
    t.string "questionnaire_type"
    t.date "questionnaire_receipt_date"
    t.boolean "testimony"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_marketing_informations_projects"
  end

  create_table "cloud_house_project_offer_reports", force: :cascade do |t|
    t.string "description"
    t.string "additional_information"
    t.string "offer_type"
    t.date "offer_review_start"
    t.date "offer_review_end"
    t.time "offer_review_time"
    t.float "offer_value"
    t.date "offer_valuation_date"
    t.string "offer_status"
    t.string "additional_client_calculation"
    t.boolean "commission_checked"
    t.bigint "reviewer_employee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "house_project_offer_reports_projects"
  end

  create_table "cloud_house_project_services", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_employee_services_id"
    t.index ["cloud_house_employee_services_id"], name: "house_project_services_employee_services"
    t.index ["cloud_house_projects_id"], name: "house_project_companies_projects"
  end

  create_table "cloud_house_project_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "users_id"
    t.index ["cloud_house_projects_id"], name: "house_project_subscribers_projects"
    t.index ["users_id"], name: "house_project_subscribers_users"
  end

  create_table "cloud_house_projects", force: :cascade do |t|
    t.bigint "main_employee_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "cloud_house_catalog_project_types_id"
    t.bigint "cloud_house_properties_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_projects_on_cloud_house_accounts_id"
    t.index ["cloud_house_catalog_project_types_id"], name: "house_projects_types"
    t.index ["cloud_house_properties_id"], name: "house_projects_properties"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_projects_workflow_statuses"
  end

  create_table "cloud_house_properties", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "cloud_house_workflow_statuses_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_properties_on_cloud_house_accounts_id"
    t.index ["cloud_house_workflow_statuses_id"], name: "house_properties_workflow_statuses"
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
    t.string "category"
    t.bigint "users"
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_activities_properties"
  end

  create_table "cloud_house_property_annuities", force: :cascade do |t|
    t.string "monthly_annuity_value"
    t.string "adjust_of_life_annuity_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_annuities_properties"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_binding_validations_properties"
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
    t.float "property_value"
    t.boolean "has_leases"
    t.date "leases_running_time"
    t.float "monthly_leasehold"
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
    t.string "attachment"
    t.string "file_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_files_on_cloud_house_properties_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_registers_properties"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "index_cloud_house_property_uses_on_cloud_house_properties_id"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_properties_id"], name: "house_property_validations_properties"
  end

  create_table "cloud_house_workflow_associations", force: :cascade do |t|
    t.string "workflow_for"
    t.boolean "global"
    t.bigint "project_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflows_id"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_associations_workflows"
    t.index ["project_type"], name: "house_workflow_associations_project_types"
  end

  create_table "cloud_house_workflow_statuses", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.boolean "initial"
    t.boolean "final"
    t.string "next_statuses"
    t.boolean "inactive"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflows_id"
    t.index ["cloud_house_workflows_id"], name: "house_workflow_statuses_workflows"
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
  add_foreign_key "cloud_driver_event_attendants", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_attendants", "users", column: "users_id"
  add_foreign_key "cloud_driver_event_details", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_files", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_focus_accounts", "accounts", column: "id"
  add_foreign_key "cloud_focus_task_details", "cloud_focus_tasks", column: "cloud_focus_tasks_id"
  add_foreign_key "cloud_focus_tasks", "accounts", column: "accounts_id"
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_catalog_business_services", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_company_categories", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_project_types", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "cloud_house_catalog_company_categories", column: "cloud_house_catalog_company_categories_id"
  add_foreign_key "cloud_house_companies", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_companies", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_companies", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_company_actions", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_activities", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_associates", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_associates", "cloud_house_employee_services", column: "cloud_house_employee_services_id"
  add_foreign_key "cloud_house_company_custom_field_values", "cloud_house_company_custom_fields", column: "cloud_house_company_custom_fields_id"
  add_foreign_key "cloud_house_company_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_company_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_company_details", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_discussions", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_discussions", "cloud_house_company_discussions", column: "cloud_house_company_discussions_id"
  add_foreign_key "cloud_house_company_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_company_files", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_subscribers", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_company_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_actions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_activities", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_activities", "users", column: "users"
  add_foreign_key "cloud_house_contact_custom_field_values", "cloud_house_contact_custom_fields", column: "cloud_house_contact_custom_fields_id"
  add_foreign_key "cloud_house_contact_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_details", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contact_discussions", column: "cloud_house_contact_discussions_id"
  add_foreign_key "cloud_house_contact_discussions", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_contact_files", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_contact_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_contacts", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_employee_actions", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_activities", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_custom_field_values", "cloud_house_employee_custom_fields", column: "cloud_house_employee_custom_fields_id"
  add_foreign_key "cloud_house_employee_custom_fields", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_details", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_discussions", "cloud_house_employee_discussions", column: "cloud_house_employee_discussions_id"
  add_foreign_key "cloud_house_employee_discussions", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_employee_files", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_services", "cloud_house_catalog_business_services", column: "cloud_house_catalog_business_services_id"
  add_foreign_key "cloud_house_employee_services", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_subscribers", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_employees", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_employees", "cloud_house_companies", column: "cloud_house_companies_id"
  add_foreign_key "cloud_house_employees", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_employees", "users", column: "users_id"
  add_foreign_key "cloud_house_project_actions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_activities", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_custom_fields", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_project_discussions", column: "cloud_house_project_discussions_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_project_files", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_marketing_informations", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_offer_reports", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_offer_reports", "users", column: "reviewer_employee_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_employee_services", column: "cloud_house_employee_services_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_projects", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_projects", "cloud_house_catalog_project_types", column: "cloud_house_catalog_project_types_id"
  add_foreign_key "cloud_house_projects", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_projects", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_projects", "users", column: "main_employee_id"
  add_foreign_key "cloud_house_properties", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_properties", "cloud_house_workflow_statuses", column: "cloud_house_workflow_statuses_id"
  add_foreign_key "cloud_house_property_actions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_activities", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_annuities", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_binding_validations", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_fields", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_custom_fields", "users", column: "users_id"
  add_foreign_key "cloud_house_property_details", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_discussions", "cloud_house_property_discussions", column: "cloud_house_property_discussions_id"
  add_foreign_key "cloud_house_property_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_property_files", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_registers", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_property_uses", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_property_validations", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_workflow_associations", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_statuses", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "settings", "accounts", column: "accounts_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
