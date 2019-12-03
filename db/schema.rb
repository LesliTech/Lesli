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

  create_table "cloud_bell_accounts", force: :cascade do |t|
  end

  create_table "cloud_bell_notifications", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.string "href"
    t.string "format"
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

  create_table "cloud_help_sla_assignments", force: :cascade do |t|
    t.string "next_sla"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_slas_id"
    t.index ["cloud_help_slas_id"], name: "help_sla_assignments_slas"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_sla_assignments_categories"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_sla_assignments_types"
  end

  create_table "cloud_help_slas", force: :cascade do |t|
    t.string "name"
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
    t.string "tags"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_workflows_id"
    t.bigint "cloud_help_ticket_priorities_id"
    t.bigint "cloud_help_ticket_sources_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_tickets_id"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_details_categories"
    t.index ["cloud_help_ticket_priorities_id"], name: "help_ticket_details_priorities"
    t.index ["cloud_help_ticket_sources_id"], name: "help_ticket_details_sources"
    t.index ["cloud_help_ticket_types_id"], name: "help_ticket_details_types"
    t.index ["cloud_help_ticket_workflows_id"], name: "help_ticket_details_workflows"
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

  create_table "cloud_help_ticket_followers", force: :cascade do |t|
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_tickets_id"
    t.bigint "users_id"
    t.index ["cloud_help_tickets_id"], name: "index_cloud_help_ticket_followers_on_cloud_help_tickets_id"
    t.index ["users_id"], name: "index_cloud_help_ticket_followers_on_users_id"
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
    t.string "next_states"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cloud_help_ticket_types_id"
    t.bigint "cloud_help_ticket_categories_id"
    t.bigint "cloud_help_ticket_states_id"
    t.index ["cloud_help_ticket_categories_id"], name: "help_ticket_workflows_categories"
    t.index ["cloud_help_ticket_states_id"], name: "help_ticket_workflows_states"
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

  create_table "cloud_lock_accounts", force: :cascade do |t|
  end

  create_table "cloud_lock_role_privileges", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_lock_roles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "cloud_lock_users", force: :cascade do |t|
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
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cloud_bell_accounts", "accounts", column: "id"
  add_foreign_key "cloud_bell_notifications", "cloud_bell_accounts", column: "cloud_bell_accounts_id"
  add_foreign_key "cloud_bell_notifications", "users", column: "users_id"
  add_foreign_key "cloud_help_accounts", "accounts", column: "id"
  add_foreign_key "cloud_help_sla_assignments", "cloud_help_slas", column: "cloud_help_slas_id"
  add_foreign_key "cloud_help_sla_assignments", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_sla_assignments", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_slas", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_actions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_activities", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_categories", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_priorities", column: "cloud_help_ticket_priorities_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_sources", column: "cloud_help_ticket_sources_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_ticket_workflows", column: "cloud_help_ticket_workflows_id"
  add_foreign_key "cloud_help_ticket_details", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_ticket_discussions", column: "cloud_help_ticket_discussions_id"
  add_foreign_key "cloud_help_ticket_discussions", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_discussions", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_files", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_followers", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_followers", "users", column: "users_id"
  add_foreign_key "cloud_help_ticket_priorities", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_sources", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_states", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_timelines", "cloud_help_tickets", column: "cloud_help_tickets_id"
  add_foreign_key "cloud_help_ticket_types", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_categories", column: "cloud_help_ticket_categories_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_states", column: "cloud_help_ticket_states_id"
  add_foreign_key "cloud_help_ticket_workflows", "cloud_help_ticket_types", column: "cloud_help_ticket_types_id"
  add_foreign_key "cloud_help_tickets", "cloud_help_accounts", column: "cloud_help_accounts_id"
  add_foreign_key "cloud_help_tickets", "users", column: "users_id"
  add_foreign_key "cloud_lock_accounts", "accounts", column: "id"
  add_foreign_key "users", "accounts", column: "accounts_id"
end
