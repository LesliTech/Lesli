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

ActiveRecord::Schema.define(version: 2040712) do

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

  create_table "cloud_house_companies", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_accounts_id"
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_companies_on_cloud_house_accounts_id"
    t.index ["cloud_house_companies_id"], name: "index_cloud_house_companies_on_cloud_house_companies_id"
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
    t.string "contact_information"
    t.string "legal_form"
    t.string "hq_email"
    t.string "hq_phone"
    t.string "hq_tax"
    t.string "brokerage"
    t.string "street_name"
    t.string "street_number"
    t.string "street_other"
    t.string "postcode"
    t.string "city_name"
    t.string "website"
    t.string "ivd"
    t.string "bvfi"
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
    t.boolean "premium_partner"
    t.boolean "specific_agreement"
    t.boolean "avv_shipped"
    t.boolean "avv_completed"
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
    t.bigint "cloud_house_company_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_companies_id"], name: "house_company_discussions_company"
    t.index ["cloud_house_company_discussions_id"], name: "house_company_discussions_discussions"
    t.index ["users_id"], name: "house_company_discussions_users"
  end

  create_table "cloud_house_company_files", force: :cascade do |t|
    t.string "name"
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
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_employee_custom_fields_contacts"
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
    t.bigint "cloud_house_companies_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_employees_on_cloud_house_accounts_id"
    t.index ["cloud_house_companies_id"], name: "house_employees_companies"
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
    t.string "icon"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_activities_on_cloud_house_projects_id"
  end

  create_table "cloud_house_project_customers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_contacts_id"
    t.index ["cloud_house_contacts_id"], name: "house_project_customers_contacts"
    t.index ["cloud_house_projects_id"], name: "house_project_customers_projects"
  end

  create_table "cloud_house_project_details", force: :cascade do |t|
    t.bigint "code"
    t.integer "project_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_workflow_details_id"
    t.bigint "cloud_house_projects_id"
    t.bigint "cloud_house_catalog_project_types_id"
    t.bigint "cloud_house_properties_id"
    t.index ["cloud_house_catalog_project_types_id"], name: "house_project_details_types"
    t.index ["cloud_house_projects_id"], name: "house_project_details_projects"
    t.index ["cloud_house_properties_id"], name: "house_project_details_properties"
    t.index ["cloud_house_workflow_details_id"], name: "house_project_details_workflow_details"
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_projects_id"
    t.index ["cloud_house_projects_id"], name: "index_cloud_house_project_files_on_cloud_house_projects_id"
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

  create_table "cloud_house_project_workflows", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_house_catalog_project_types_id"
    t.bigint "cloud_house_workflows_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "house_project_workflows_accounts"
    t.index ["cloud_house_catalog_project_types_id"], name: "house_project   _workflows_types"
    t.index ["cloud_house_workflows_id"], name: "house_project_workflows_workflows"
  end

  create_table "cloud_house_projects", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_house_accounts_id"
    t.index ["cloud_house_accounts_id"], name: "index_cloud_house_projects_on_cloud_house_accounts_id"
    t.index ["users_id"], name: "index_cloud_house_projects_on_users_id"
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
  add_foreign_key "cloud_house_accounts", "accounts", column: "id"
  add_foreign_key "cloud_house_catalog_business_services", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_catalog_project_types", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_companies", "cloud_house_companies", column: "cloud_house_companies_id"
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
  add_foreign_key "cloud_house_employee_actions", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_activities", "cloud_house_employees", column: "cloud_house_employees_id"
  add_foreign_key "cloud_house_employee_custom_field_values", "cloud_house_employee_custom_fields", column: "cloud_house_employee_custom_fields_id"
  add_foreign_key "cloud_house_employee_custom_fields", "cloud_house_contacts", column: "cloud_house_contacts_id"
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
  add_foreign_key "cloud_house_project_actions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_activities", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_contacts", column: "cloud_house_contacts_id"
  add_foreign_key "cloud_house_project_customers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_catalog_project_types", column: "cloud_house_catalog_project_types_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_properties", column: "cloud_house_properties_id"
  add_foreign_key "cloud_house_project_details", "cloud_house_workflow_details", column: "cloud_house_workflow_details_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_project_discussions", column: "cloud_house_project_discussions_id"
  add_foreign_key "cloud_house_project_discussions", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_discussions", "users", column: "users_id"
  add_foreign_key "cloud_house_project_files", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_employee_services", column: "cloud_house_employee_services_id"
  add_foreign_key "cloud_house_project_services", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "cloud_house_projects", column: "cloud_house_projects_id"
  add_foreign_key "cloud_house_project_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_house_project_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_project_workflows", "cloud_house_catalog_project_types", column: "cloud_house_catalog_project_types_id"
  add_foreign_key "cloud_house_project_workflows", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_projects", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_projects", "users", column: "users_id"
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
  add_foreign_key "cloud_house_workflow_details", "cloud_house_workflow_states", column: "cloud_house_workflow_states_id"
  add_foreign_key "cloud_house_workflow_details", "cloud_house_workflows", column: "cloud_house_workflows_id"
  add_foreign_key "cloud_house_workflow_states", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "cloud_house_workflows", "cloud_house_accounts", column: "cloud_house_accounts_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
