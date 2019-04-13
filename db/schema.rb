# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_15_232022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "agents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "browser_id"
    t.boolean "bot", default: false, null: false
    t.boolean "mobile", default: false, null: false
    t.boolean "active", default: true, null: false
    t.boolean "locked", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.string "name", null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id"
    t.index ["name"], name: "index_agents_on_name"
  end

  create_table "biovision_components", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.json "settings", default: {}, null: false
    t.index ["slug"], name: "index_biovision_components_on_slug", unique: true
  end

  create_table "biovision_parameters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "biovision_component_id", null: false
    t.boolean "deletable", default: true, null: false
    t.string "slug", null: false
    t.string "name"
    t.text "value"
    t.text "description"
    t.index ["biovision_component_id"], name: "index_biovision_parameters_on_biovision_component_id"
  end

  create_table "browsers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bot", default: false, null: false
    t.boolean "mobile", default: false, null: false
    t.boolean "active", default: true, null: false
    t.boolean "locked", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.integer "agents_count", default: 0, null: false
    t.string "name", null: false
    t.index ["name"], name: "index_browsers_on_name"
  end

  create_table "code_types", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
  end

  create_table "codes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "code_type_id", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.integer "quantity", limit: 2, default: 1, null: false
    t.string "body", null: false
    t.string "payload"
    t.json "data", default: {}, null: false
    t.index ["agent_id"], name: "index_codes_on_agent_id"
    t.index ["body", "code_type_id", "quantity"], name: "index_codes_on_body_and_code_type_id_and_quantity"
    t.index ["code_type_id"], name: "index_codes_on_code_type_id"
    t.index ["user_id"], name: "index_codes_on_user_id"
  end

  create_table "dreams", comment: "Dreams of users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "sleep_place_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.boolean "visible", default: true, null: false
    t.boolean "needs_interpretation", default: false, null: false
    t.boolean "interpreted", default: false, null: false
    t.integer "lucidity", limit: 2, default: 0, null: false
    t.integer "privacy", limit: 2, default: 0
    t.integer "comments_count", default: 0, null: false
    t.string "title"
    t.text "body"
    t.index "date_trunc('month'::text, created_at)", name: "dreams_created_month_idx"
    t.index ["agent_id"], name: "index_dreams_on_agent_id"
    t.index ["sleep_place_id"], name: "index_dreams_on_sleep_place_id"
    t.index ["user_id"], name: "index_dreams_on_user_id"
    t.index ["visible", "privacy"], name: "index_dreams_on_visible_and_privacy"
  end

  create_table "editable_blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.boolean "visible", default: true, null: false
    t.boolean "raw_output", default: false, null: false
    t.string "slug", null: false
    t.string "name"
    t.string "description"
    t.string "image"
    t.string "title"
    t.text "lead"
    t.text "body"
    t.text "footer"
    t.index ["language_id"], name: "index_editable_blocks_on_language_id"
  end

  create_table "editable_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.boolean "visible", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.string "slug", null: false
    t.string "name", null: false
    t.string "nav_group"
    t.string "url"
    t.string "image"
    t.string "image_alt_text"
    t.string "meta_title", default: "", null: false
    t.string "meta_keywords", default: "", null: false
    t.string "meta_description", default: "", null: false
    t.text "body", default: "", null: false
    t.index ["language_id"], name: "index_editable_pages_on_language_id"
  end

  create_table "feedback_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.boolean "processed"
    t.boolean "consent", default: false, null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "image"
    t.text "comment"
    t.index ["agent_id"], name: "index_feedback_requests_on_agent_id"
    t.index ["language_id"], name: "index_feedback_requests_on_language_id"
  end

  create_table "foreign_sites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.string "name", null: false
    t.integer "foreign_users_count", default: 0, null: false
  end

  create_table "foreign_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "foreign_site_id", null: false
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.string "slug", null: false
    t.string "email"
    t.string "name"
    t.text "data"
    t.index ["agent_id"], name: "index_foreign_users_on_agent_id"
    t.index ["foreign_site_id"], name: "index_foreign_users_on_foreign_site_id"
    t.index ["user_id"], name: "index_foreign_users_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "users_count", default: 0, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.string "slug", null: false
    t.string "code", null: false
  end

  create_table "link_block_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "link_block_id", null: false
    t.boolean "visible", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.string "slug"
    t.string "image"
    t.string "image_alt_text"
    t.string "title"
    t.string "button_text"
    t.string "button_url"
    t.text "body"
    t.index ["link_block_id"], name: "index_link_block_items_on_link_block_id"
  end

  create_table "link_blocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.boolean "visible", default: true, null: false
    t.string "slug", null: false
    t.string "title"
    t.text "lead"
    t.text "footer_text"
    t.index ["language_id"], name: "index_link_blocks_on_language_id"
  end

  create_table "login_attempts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.string "password", default: "", null: false
    t.index ["agent_id"], name: "index_login_attempts_on_agent_id"
    t.index ["user_id"], name: "index_login_attempts_on_user_id"
  end

  create_table "media_files", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "media_folder_id"
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.boolean "locked", default: false, null: false
    t.string "uuid", null: false
    t.string "snapshot"
    t.string "file"
    t.string "mime_type"
    t.string "original_name"
    t.string "name", null: false
    t.string "description"
    t.index ["agent_id"], name: "index_media_files_on_agent_id"
    t.index ["media_folder_id"], name: "index_media_files_on_media_folder_id"
    t.index ["user_id"], name: "index_media_files_on_user_id"
  end

  create_table "media_folders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.integer "parent_id"
    t.integer "media_files_count", default: 0, null: false
    t.integer "depth", limit: 2, default: 0, null: false
    t.string "uuid", null: false
    t.string "snapshot"
    t.string "parents_cache", default: "", null: false
    t.string "name", null: false
    t.integer "children_cache", default: [], null: false, array: true
    t.index ["agent_id"], name: "index_media_folders_on_agent_id"
    t.index ["user_id"], name: "index_media_folders_on_user_id"
  end

  create_table "metric_values", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.datetime "time", null: false
    t.integer "quantity", default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx"
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "incremental", default: false, null: false
    t.boolean "start_with_zero", default: false, null: false
    t.boolean "show_on_dashboard", default: true, null: false
    t.integer "default_period", limit: 2, default: 7, null: false
    t.integer "value", default: 0, null: false
    t.integer "previous_value", default: 0, null: false
    t.string "name", null: false
    t.string "description", default: "", null: false
    t.bigint "biovision_component_id"
    t.index ["biovision_component_id"], name: "index_metrics_on_biovision_component_id"
  end

  create_table "privilege_group_privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "privilege_group_id", null: false
    t.bigint "privilege_id", null: false
    t.boolean "deletable", default: true, null: false
    t.index ["privilege_group_id"], name: "index_privilege_group_privileges_on_privilege_group_id"
    t.index ["privilege_id"], name: "index_privilege_group_privileges_on_privilege_id"
  end

  create_table "privilege_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletable", default: true, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description", default: "", null: false
    t.index ["slug"], name: "index_privilege_groups_on_slug", unique: true
  end

  create_table "privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.boolean "regional", default: false, null: false
    t.boolean "administrative", default: true, null: false
    t.boolean "deletable", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.integer "users_count", default: 0, null: false
    t.string "parents_cache", default: "", null: false
    t.integer "children_cache", default: [], null: false, array: true
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description", default: "", null: false
    t.index ["slug"], name: "index_privileges_on_slug", unique: true
  end

  create_table "sleep_places", comment: "Places where users sleep", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "dreams_count", default: 0, null: false
    t.string "name"
    t.index ["user_id"], name: "index_sleep_places_on_user_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "last_used"
    t.boolean "active", default: true, null: false
    t.string "token"
    t.index ["agent_id"], name: "index_tokens_on_agent_id"
    t.index ["last_used"], name: "index_tokens_on_last_used"
    t.index ["token"], name: "index_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "user_languages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "language_id", null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_privileges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.bigint "user_id", null: false
    t.bigint "privilege_id", null: false
    t.index ["privilege_id"], name: "index_user_privileges_on_privilege_id"
    t.index ["user_id"], name: "index_user_privileges_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "region_id"
    t.bigint "language_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.integer "inviter_id"
    t.integer "native_id"
    t.integer "follower_count", default: 0, null: false
    t.integer "followee_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "dreams_count", default: 0, null: false
    t.integer "authority", default: 0, null: false
    t.integer "upvote_count", default: 0, null: false
    t.integer "downvote_count", default: 0, null: false
    t.integer "vote_result", default: 0, null: false
    t.integer "balance", default: 0, null: false
    t.boolean "super_user", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.boolean "bot", default: false, null: false
    t.boolean "allow_login", default: true, null: false
    t.boolean "email_confirmed", default: false, null: false
    t.boolean "phone_confirmed", default: false, null: false
    t.boolean "allow_mail", default: true, null: false
    t.boolean "foreign_slug", default: false, null: false
    t.boolean "consent", default: false, null: false
    t.datetime "last_seen"
    t.date "birthday"
    t.string "slug", null: false
    t.string "screen_name", null: false
    t.string "password_digest"
    t.string "email"
    t.string "phone"
    t.string "image"
    t.string "notice"
    t.string "search_string"
    t.string "referral_link"
    t.json "profile_data", default: {}, null: false
    t.uuid "uuid"
    t.json "data", default: {"profile"=>{}}, null: false
    t.index ["agent_id"], name: "index_users_on_agent_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["referral_link"], name: "index_users_on_referral_link"
    t.index ["screen_name"], name: "index_users_on_screen_name"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "agents", "browsers", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biovision_parameters", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "codes", "code_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "dreams", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreams", "sleep_places", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreams", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editable_blocks", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editable_pages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "feedback_requests", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "feedback_requests", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "foreign_users", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "foreign_users", "foreign_sites", on_update: :cascade, on_delete: :cascade
  add_foreign_key "foreign_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "link_block_items", "link_blocks", on_update: :cascade, on_delete: :cascade
  add_foreign_key "link_blocks", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "login_attempts", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "login_attempts", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "media_files", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "media_files", "media_folders", on_update: :cascade, on_delete: :nullify
  add_foreign_key "media_files", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "media_folders", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "media_folders", "media_folders", column: "parent_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "media_folders", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "metric_values", "metrics", on_update: :cascade, on_delete: :cascade
  add_foreign_key "metrics", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privilege_group_privileges", "privilege_groups", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privilege_group_privileges", "privileges", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privileges", "privileges", column: "parent_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "sleep_places", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tokens", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "tokens", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_privileges", "privileges", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_privileges", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "inviter_id", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "native_id", on_update: :cascade, on_delete: :nullify
end
