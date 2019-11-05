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

ActiveRecord::Schema.define(version: 8020001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_plans", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 12, scale: 6
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
    t.bigint "account_plans_id"
    t.index ["account_plans_id"], name: "index_accounts_on_account_plans_id"
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

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "cloud_bell_accounts", force: :cascade do |t|
  end

  create_table "cloud_bell_emails", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_bell_accounts_id"
    t.index ["cloud_bell_accounts_id"], name: "index_cloud_bell_emails_on_cloud_bell_accounts_id"
  end

  create_table "cloud_bell_messages", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_bell_accounts_id"
    t.index ["cloud_bell_accounts_id"], name: "index_cloud_bell_messages_on_cloud_bell_accounts_id"
  end

  create_table "cloud_bell_notification_deliverers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_bell_notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "href"
    t.string "format"
    t.boolean "read"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_bell_notification_deliverer_id"
    t.bigint "users_id"
    t.bigint "cloud_bell_accounts_id"
    t.index ["cloud_bell_accounts_id"], name: "index_cloud_bell_notifications_on_cloud_bell_accounts_id"
    t.index ["cloud_bell_notification_deliverer_id"], name: "bell_notifications_deliverers"
    t.index ["users_id"], name: "index_cloud_bell_notifications_on_users_id"
  end

  create_table "cloud_books_accounts", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_driver_accounts", force: :cascade do |t|
  end

  create_table "cloud_driver_calendar_actions", force: :cascade do |t|
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

  create_table "cloud_driver_calendar_attachments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_attachments_calendars"
  end

  create_table "cloud_driver_calendar_comments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_comments_calendars"
  end

  create_table "cloud_driver_calendar_details", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "calendar_details_calendars"
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

  create_table "cloud_driver_event_attachments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_attachments_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_comments", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_comments_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_event_details", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_events_id"
    t.index ["cloud_driver_events_id"], name: "index_cloud_driver_event_details_on_cloud_driver_events_id"
  end

  create_table "cloud_driver_events", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_driver_calendars_id"
    t.index ["cloud_driver_calendars_id"], name: "index_cloud_driver_events_on_cloud_driver_calendars_id"
  end

  create_table "cloud_help_accounts", force: :cascade do |t|
  end

  create_table "cloud_help_slas", force: :cascade do |t|
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
    t.integer "type"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_activities_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_categories_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_details", force: :cascade do |t|
    t.string "subject"
    t.text "description"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_states_id"
    t.bigint "cloud_help_ticket_priorities_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_priorities_id"], name: "help_ticket_details_priorities"
    t.index ["cloud_help_ticket_states_id"], name: "help_ticket_details_states"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_details_types"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_details_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_discussions_id"], name: "ticket_comments"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_discussions_on_cloud_help_tickets_id"
    t.index ["users_id"], name: "index_cloud_help_ticket_discussions_on_users_id"
  end

  create_table "cloud_help_ticket_files", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_files_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_followers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "cloud_help_ticket_states", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_states_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_timelines", force: :cascade do |t|
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

  create_table "cloud_help_tickets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_tickets_on_cloud_help_accounts_id"
    t.index ["users_id"], name: "index_cloud_help_tickets_on_users_id"
  end

  create_table "cloud_kb_accounts", force: :cascade do |t|
  end

  create_table "cloud_kb_article_actions", force: :cascade do |t|
    t.integer "type"
    t.string "instructions"
    t.datetime "deadline"
    t.boolean "complete"
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_actions_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_activities", force: :cascade do |t|
    t.integer "type"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_activities_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_attachments", force: :cascade do |t|
    t.string "filename"
    t.string "path"
    t.integer "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_attachments_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_comments", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_article_comments_id"
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_article_comments_id"], name: "article_comments"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_comments_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_details", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_details_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_tags", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_accounts_id"
    t.index ["cloud_kb_accounts_id"], name: "index_cloud_kb_article_tags_on_cloud_kb_accounts_id"
  end

  create_table "cloud_kb_article_topics", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_accounts_id"
    t.index ["cloud_kb_accounts_id"], name: "index_cloud_kb_article_topics_on_cloud_kb_accounts_id"
  end

  create_table "cloud_kb_articles", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_accounts_id"
    t.index ["cloud_kb_accounts_id"], name: "index_cloud_kb_articles_on_cloud_kb_accounts_id"
  end

  create_table "cloud_lock_accounts", force: :cascade do |t|
  end

  create_table "cloud_panel_accounts", force: :cascade do |t|
  end

  create_table "cloud_team_accounts", force: :cascade do |t|
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
    t.integer "type"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_activities_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_attachments", force: :cascade do |t|
    t.string "filename"
    t.string "path"
    t.integer "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_attachment_employees"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_details_employees"
  end

  create_table "cloud_team_employee_contact_emergency_details", force: :cascade do |t|
    t.string "full_name"
    t.string "relation"
    t.string "phone_number_1"
    t.string "phone_number_2"
    t.string "full_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_contact_emergency_details_employees"
  end

  create_table "cloud_team_employee_details", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "third_name"
    t.string "surname"
    t.string "second_surname"
    t.string "married_name"
    t.date "birthdate"
    t.string "phone_number"
    t.string "mobile_number"
    t.string "fax"
    t.string "email"
    t.string "address"
    t.string "location"
    t.bigint "nationality_country_id"
    t.string "identity_document_number"
    t.string "passport_number"
    t.integer "marital_status"
    t.string "gender"
    t.string "blood_group"
    t.text "biography"
    t.text "family_background"
    t.text "health_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_details_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_employee_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employee_discussions_id"], name: "employee_discussions_discussions"
    t.index ["cloud_team_employees_id"], name: "employee_discussions"
    t.index ["users_id"], name: "index_cloud_team_employee_discussions_on_users_id"
  end

  create_table "cloud_team_employee_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "index_cloud_team_employee_locations_on_cloud_team_employees_id"
  end

  create_table "cloud_team_employee_social_accounts", force: :cascade do |t|
    t.string "facebook"
    t.string "twitter"
    t.string "slack"
    t.string "skype"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cloud_team_employees_id"
    t.index ["cloud_team_employees_id"], name: "team_employee_social_account_employees"
  end

  create_table "cloud_team_employees", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_team_accounts_id"
    t.index ["cloud_team_accounts_id"], name: "index_cloud_team_employees_on_cloud_team_accounts_id"
  end

  create_table "company_currencies", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_company_currencies_on_accounts_id"
  end

  create_table "company_location_cities", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_location_states_id"
    t.index ["company_location_states_id"], name: "index_company_location_cities_on_company_location_states_id"
  end

  create_table "company_location_continents", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_company_location_continents_on_accounts_id"
  end

  create_table "company_location_countries", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_location_continents_id"
    t.index ["company_location_continents_id"], name: "company_location_countries_continents"
  end

  create_table "company_location_states", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_location_countries_id"
    t.index ["company_location_countries_id"], name: "index_company_location_states_on_company_location_countries_id"
  end

  create_table "company_role_privileges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_roles_id"
    t.index ["company_roles_id"], name: "index_company_role_privileges_on_company_roles_id"
  end

  create_table "company_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_company_roles_on_accounts_id"
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
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "account_plans", column: "account_plans_id"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_emails", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_messages", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_notification_deliverers"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
  add_foreign_key "cloud_driver_accounts", "accounts", column: "id"
  add_foreign_key "cloud_driver_calendar_actions", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_activities", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_attachments", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_comments", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendar_details", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_driver_calendars", "cloud_driver_accounts", column: "cloud_driver_accounts_id"
  add_foreign_key "cloud_driver_event_actions", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_activities", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_attachments", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_comments", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_event_details", "cloud_driver_events", column: "cloud_driver_events_id"
  add_foreign_key "cloud_driver_events", "cloud_driver_calendars", column: "cloud_driver_calendars_id"
  add_foreign_key "cloud_help_accounts", "accounts", column: "id"
  add_foreign_key "cloud_help_slas", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_actions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_activities", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_categories", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_priorities", column: "cloud_help_ticket_priorities_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_states", column: "cloud_help_ticket_states_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_ticket_discussions", column: "cloud_help_ticket_discussions_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_files", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_priorities", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_sources", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_states", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_timelines", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_types", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_tickets", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_tickets", "users", column: "users_id"
  add_foreign_key "cloud_kb_accounts", "accounts", column: "id"
  add_foreign_key "cloud_kb_article_actions", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_activities", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_attachments", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_comments", "cloud_kb_article_comments", column: "cloud_kb_article_comments_id"
  add_foreign_key "cloud_kb_article_comments", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_details", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_tags", "cloud_kb_accounts", column: "cloud_kb_accounts_id"
  add_foreign_key "cloud_kb_article_topics", "cloud_kb_accounts", column: "cloud_kb_accounts_id"
  add_foreign_key "cloud_kb_articles", "cloud_kb_accounts", column: "cloud_kb_accounts_id"
  add_foreign_key "cloud_kb_articles", "cloud_kb_articles", column: "parent_id"
  add_foreign_key "cloud_lock_accounts", "accounts", column: "id"
  add_foreign_key "cloud_panel_accounts", "accounts", column: "id"
  add_foreign_key "cloud_team_accounts", "accounts", column: "id"
  add_foreign_key "cloud_team_employee_actions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_activities", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_attachments", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_contact_emergency_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_details", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_discussions", "cloud_team_employee_discussions", column: "cloud_team_employee_discussions_id"
  add_foreign_key "cloud_team_employee_discussions", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_discussions", "users", column: "users_id"
  add_foreign_key "cloud_team_employee_locations", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employee_social_accounts", "cloud_team_employees", column: "cloud_team_employees_id"
  add_foreign_key "cloud_team_employees", "cloud_team_accounts", column: "cloud_team_accounts_id"
  add_foreign_key "company_currencies", "accounts", column: "accounts_id"
  add_foreign_key "company_location_cities", "company_location_states", column: "company_location_states_id"
  add_foreign_key "company_location_continents", "accounts", column: "accounts_id"
  add_foreign_key "company_location_countries", "company_location_continents", column: "company_location_continents_id"
  add_foreign_key "company_location_states", "company_location_countries", column: "company_location_countries_id"
  add_foreign_key "company_role_privileges", "company_roles", column: "company_roles_id"
  add_foreign_key "company_roles", "accounts", column: "accounts_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
