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

  create_table "cloud_babel_translation_modules", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_babel_translation_objects", force: :cascade do |t|
    t.string "name"
    t.string "object_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_babel_translation_objects_id"
    t.bigint "cloud_babel_translation_modules_id"
    t.index ["cloud_babel_translation_modules_id"], name: "babel_translation_objects_modules"
    t.index ["cloud_babel_translation_objects_id"], name: "cloud_babel_translation_objects_objects"
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
    t.bigint "cloud_babel_translation_objects_id"
    t.index ["cloud_babel_translation_objects_id"], name: "babel_translation_strings_objects"
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
    t.integer "type"
    t.string "value"
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
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_workflow_details_id"
    t.bigint "cloud_help_ticket_priorities_id"
    t.bigint "cloud_help_ticket_sources_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_details_categories"
    t.index ["cloud_help_ticket_priorities_id"], name: "help_ticket_details_priorities"
    t.index ["cloud_help_ticket_sources_id"], name: "help_ticket_details_sources"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_details_types"
    t.index ["cloud_help_ticket_workflow_details_id"], name: "help_ticket_details_workflow_details"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_details_on_cloud_help_tickets_id"
  end

  create_table "cloud_help_ticket_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
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

  create_table "cloud_help_ticket_states", force: :cascade do |t|
    t.string "name"
    t.boolean "initial", default: false
    t.boolean "final", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_accounts_id"
    t.index ["cloud_help_accounts_id"], name: "index_cloud_help_ticket_states_on_cloud_help_accounts_id"
  end

  create_table "cloud_help_ticket_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.bigint "users_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_subscribers_on_cloud_help_tickets_id"
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

  create_table "cloud_help_ticket_workflow_details", force: :cascade do |t|
    t.string "next_states"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_workflows_id"
    t.bigint "cloud_help_ticket_states_id"
    t.index ["cloud_help_ticket_states_id"], name: "help_ticket_workflow_details_states"
    t.index ["cloud_help_ticket_workflows_id"], name: "help_ticket_workflow_details"
  end

  create_table "cloud_help_ticket_workflows", force: :cascade do |t|
    t.boolean "default", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_slas_id"
    t.index ["cloud_help_slas_id"], name: "help_ticket_workflows_slas"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_workflows_categories"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_workflows_types"
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

  create_table "cloud_kb_article_custom_fields", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_custom_fields_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_details", force: :cascade do |t|
    t.string "title"
    t.string "excerpt"
    t.string "tags"
    t.integer "status"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_catalog_categories_id"
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_details_on_cloud_kb_articles_id"
    t.index ["cloud_kb_catalog_categories_id"], name: "kb_article_details_catalog_categories"
  end

  create_table "cloud_kb_article_discussions", force: :cascade do |t|
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_article_discussions_id"
    t.bigint "users_id"
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_article_discussions_id"], name: "article_comments"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_discussions_on_cloud_kb_articles_id"
    t.index ["users_id"], name: "index_cloud_kb_article_discussions_on_users_id"
  end

  create_table "cloud_kb_article_files", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_files_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_subscribers", force: :cascade do |t|
    t.integer "event"
    t.integer "notification_type"
    t.bigint "users_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_subscribers_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_article_terms", force: :cascade do |t|
    t.string "slug"
    t.string "path"
    t.integer "views", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_article_terms_on_cloud_kb_articles_id"
  end

  create_table "cloud_kb_articles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "cloud_kb_accounts_id"
    t.bigint "cloud_kb_articles_id"
    t.index ["cloud_kb_accounts_id"], name: "index_cloud_kb_articles_on_cloud_kb_accounts_id"
    t.index ["cloud_kb_articles_id"], name: "index_cloud_kb_articles_on_cloud_kb_articles_id"
    t.index ["users_id"], name: "index_cloud_kb_articles_on_users_id"
  end

  create_table "cloud_kb_catalog_categories", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "ancestry"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_kb_accounts_id"
    t.index ["cloud_kb_accounts_id"], name: "index_cloud_kb_catalog_categories_on_cloud_kb_accounts_id"
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
  add_foreign_key "cloud_babel_translation_objects", "cloud_babel_translation_modules", column: "cloud_babel_translation_modules_id"
  add_foreign_key "cloud_babel_translation_objects", "cloud_babel_translation_objects", column: "cloud_babel_translation_objects_id"
  add_foreign_key "cloud_babel_translation_strings", "cloud_babel_translation_objects", column: "cloud_babel_translation_objects_id"
  add_foreign_key "cloud_babel_translation_strings", "users", column: "users_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
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
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_workflow_details", column: "cloud_help_ticket_workflow_details_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_ticket_discussions", column: "cloud_help_ticket_discussions_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_files", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_priorities", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_sources", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_states", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_subscribers", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_subscribers", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_timelines", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_types", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_workflow_details", "cloud_help_ticket_states", column: "cloud_help_ticket_states_id"
  add_foreign_key "cloud_help_ticket_workflow_details", "cloud_help_ticket_workflows", column: "cloud_help_ticket_workflows_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_slas", column: "cloud_help_slas_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_tickets", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_tickets", "users", column: "users_id"
  add_foreign_key "cloud_kb_accounts", "accounts", column: "id"
  add_foreign_key "cloud_kb_article_actions", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_activities", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_custom_fields", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_details", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_details", "cloud_kb_catalog_categories", column: "cloud_kb_catalog_categories_id"
  add_foreign_key "cloud_kb_article_discussions", "cloud_kb_article_discussions", column: "cloud_kb_article_discussions_id"
  add_foreign_key "cloud_kb_article_discussions", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_discussions", "users", column: "users_id"
  add_foreign_key "cloud_kb_article_files", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_subscribers", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_article_terms", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_articles", "cloud_kb_accounts", column: "cloud_kb_accounts_id"
  add_foreign_key "cloud_kb_articles", "cloud_kb_articles", column: "cloud_kb_articles_id"
  add_foreign_key "cloud_kb_articles", "users", column: "users_id"
  add_foreign_key "cloud_kb_catalog_categories", "cloud_kb_accounts", column: "cloud_kb_accounts_id"
  add_foreign_key "cloud_lock_accounts", "accounts", column: "id"
  add_foreign_key "cloud_lock_role_privileges", "cloud_lock_roles", column: "cloud_lock_roles_id"
  add_foreign_key "cloud_lock_roles", "cloud_lock_accounts", column: "cloud_lock_accounts_id"
  add_foreign_key "cloud_lock_user_details", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "cloud_lock_roles", column: "cloud_lock_roles_id"
end
