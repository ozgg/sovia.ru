# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_12_25_192717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_mailbox_inbound_emails", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.string "message_id", null: false
    t.string "message_checksum", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["message_id", "message_checksum"], name: "index_action_mailbox_inbound_emails_uniqueness", unique: true
  end

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "agents", comment: "User agents", force: :cascade do |t|
    t.bigint "browser_id"
    t.integer "object_count", default: 0, null: false
    t.boolean "banned", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id"
    t.index ["name"], name: "index_agents_on_name", unique: true
    t.index ["object_count"], name: "index_agents_on_object_count"
  end

  create_table "biovision_component_users", comment: "Privileges and settings for users in components", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id", null: false
    t.boolean "administrator", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "data", default: {}, null: false
    t.index ["biovision_component_id"], name: "index_biovision_component_users_on_biovision_component_id"
    t.index ["data"], name: "index_biovision_component_users_on_data", using: :gin
    t.index ["user_id"], name: "index_biovision_component_users_on_user_id"
  end

  create_table "biovision_components", comment: "Biovision CMS components", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug", null: false
    t.jsonb "settings", default: {}, null: false
    t.jsonb "parameters", default: {}, null: false
    t.index ["slug"], name: "index_biovision_components_on_slug", unique: true
  end

  create_table "browsers", comment: "Browsers", force: :cascade do |t|
    t.boolean "mobile", default: false, null: false
    t.boolean "banned", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "agents_count", default: 0, null: false
    t.string "name", null: false
    t.string "version", null: false
    t.index ["name", "version"], name: "index_browsers_on_name_and_version", unique: true
  end

  create_table "codes", comment: "Codes for different purposes", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.bigint "ip_address_id"
    t.integer "quantity", default: 1, null: false
    t.string "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_codes_on_agent_id"
    t.index ["biovision_component_id"], name: "index_codes_on_biovision_component_id"
    t.index ["body"], name: "index_codes_on_body", unique: true
    t.index ["data"], name: "index_codes_on_data", using: :gin
    t.index ["ip_address_id"], name: "index_codes_on_ip_address_id"
    t.index ["user_id"], name: "index_codes_on_user_id"
  end

  create_table "dynamic_blocks", comment: "Dynamic blocks", force: :cascade do |t|
    t.string "slug", null: false
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "body"
    t.jsonb "data", default: {}, null: false
    t.index ["data"], name: "index_dynamic_blocks_on_data", using: :gin
    t.index ["slug"], name: "index_dynamic_blocks_on_slug", unique: true
  end

  create_table "dynamic_pages", comment: "Dynamic pages", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "simple_image_id"
    t.bigint "language_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "visible", default: true, null: false
    t.string "slug", null: false
    t.string "url"
    t.string "name"
    t.text "body", default: "", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["data"], name: "index_dynamic_pages_on_data", using: :gin
    t.index ["language_id"], name: "index_dynamic_pages_on_language_id"
    t.index ["simple_image_id"], name: "index_dynamic_pages_on_simple_image_id"
    t.index ["url"], name: "index_dynamic_pages_on_url"
    t.index ["uuid"], name: "index_dynamic_pages_on_uuid", unique: true
  end

  create_table "ip_addresses", comment: "IP addresses", force: :cascade do |t|
    t.inet "ip", null: false
    t.integer "object_count", default: 0, null: false
    t.boolean "banned", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ip"], name: "index_ip_addresses_on_ip", unique: true
    t.index ["object_count"], name: "index_ip_addresses_on_object_count"
  end

  create_table "languages", comment: "Interface and content languages", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.integer "object_count", default: 0, null: false
    t.string "slug", null: false
    t.string "code", null: false
  end

  create_table "login_attempts", comment: "Failed login attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.bigint "ip_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password", default: "", null: false
    t.index ["agent_id"], name: "index_login_attempts_on_agent_id"
    t.index ["ip_address_id"], name: "index_login_attempts_on_ip_address_id"
    t.index ["user_id"], name: "index_login_attempts_on_user_id"
  end

  create_table "metric_values", comment: "Component metric values", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.datetime "time", null: false
    t.integer "quantity", default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx"
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", comment: "Component metrics", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "incremental", default: false, null: false
    t.boolean "start_with_zero", default: true, null: false
    t.boolean "show_on_dashboard", default: true, null: false
    t.integer "default_period", limit: 2, default: 7, null: false
    t.integer "value", default: 0, null: false
    t.integer "previous_value", default: 0, null: false
    t.string "name", null: false
    t.index ["biovision_component_id", "name"], name: "index_metrics_on_biovision_component_id_and_name"
    t.index ["biovision_component_id"], name: "index_metrics_on_biovision_component_id"
  end

  create_table "navigation_group_pages", comment: "Dynamic pages in navigation groups", force: :cascade do |t|
    t.bigint "navigation_group_id", null: false
    t.bigint "dynamic_page_id", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dynamic_page_id"], name: "index_navigation_group_pages_on_dynamic_page_id"
    t.index ["navigation_group_id"], name: "index_navigation_group_pages_on_navigation_group_id"
  end

  create_table "navigation_groups", comment: "Navigation groups", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "dynamic_pages_count", default: 0, null: false
    t.string "slug", null: false
    t.string "name", null: false
    t.index ["slug"], name: "index_navigation_groups_on_slug", unique: true
  end

  create_table "notifications", comment: "Component notifications for users", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id", null: false
    t.boolean "email_sent", default: false, null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "data", default: {}, null: false
    t.index ["biovision_component_id"], name: "index_notifications_on_biovision_component_id"
    t.index ["data"], name: "index_notifications_on_data", using: :gin
    t.index ["user_id"], name: "index_notifications_on_user_id"
    t.index ["uuid"], name: "index_notifications_on_uuid", unique: true
  end

  create_table "simple_image_tag_images", comment: "Links between simple images and tags", force: :cascade do |t|
    t.bigint "simple_image_id", null: false
    t.bigint "simple_image_tag_id", null: false
    t.index ["simple_image_id"], name: "index_simple_image_tag_images_on_simple_image_id"
    t.index ["simple_image_tag_id"], name: "index_simple_image_tag_images_on_simple_image_tag_id"
  end

  create_table "simple_image_tags", comment: "Tags for simple images", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "simple_images_count", default: 0, null: false
    t.index ["name"], name: "index_simple_image_tags_on_name"
  end

  create_table "simple_images", comment: "Universal simple images", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.bigint "ip_address_id"
    t.uuid "uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "object_count", default: 0, null: false
    t.string "image"
    t.string "image_alt_text", default: "", null: false
    t.string "caption"
    t.string "source_name"
    t.string "source_link"
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_simple_images_on_agent_id"
    t.index ["biovision_component_id"], name: "index_simple_images_on_biovision_component_id"
    t.index ["data"], name: "index_simple_images_on_data", using: :gin
    t.index ["ip_address_id"], name: "index_simple_images_on_ip_address_id"
    t.index ["user_id"], name: "index_simple_images_on_user_id"
    t.index ["uuid"], name: "index_simple_images_on_uuid", unique: true
  end

  create_table "tokens", comment: "Authentication tokens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.bigint "ip_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "last_used"
    t.boolean "active", default: true, null: false
    t.string "token", null: false
    t.index ["agent_id"], name: "index_tokens_on_agent_id"
    t.index ["ip_address_id"], name: "index_tokens_on_ip_address_id"
    t.index ["last_used"], name: "index_tokens_on_last_used"
    t.index ["token"], name: "index_tokens_on_token", unique: true
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "user_languages", comment: "Languages for users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "users", comment: "Users", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "language_id"
    t.bigint "agent_id"
    t.bigint "ip_address_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "primary_id"
    t.integer "inviter_id"
    t.boolean "super_user", default: false, null: false
    t.boolean "banned", default: false, null: false
    t.boolean "bot", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.boolean "email_confirmed", default: false, null: false
    t.boolean "phone_confirmed", default: false, null: false
    t.boolean "allow_mail", default: true, null: false
    t.datetime "last_seen"
    t.date "birthday"
    t.string "slug", null: false
    t.string "screen_name", null: false
    t.string "password_digest", null: false
    t.string "email"
    t.string "phone"
    t.string "image"
    t.string "notice"
    t.string "referral_link"
    t.jsonb "data", default: {}, null: false
    t.jsonb "profile", default: {}, null: false
    t.index ["agent_id"], name: "index_users_on_agent_id"
    t.index ["data"], name: "index_users_on_data", using: :gin
    t.index ["email"], name: "index_users_on_email"
    t.index ["inviter_id"], name: "index_users_on_inviter_id"
    t.index ["ip_address_id"], name: "index_users_on_ip_address_id"
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["primary_id"], name: "index_users_on_primary_id"
    t.index ["profile"], name: "index_users_on_profile", using: :gin
    t.index ["referral_link"], name: "index_users_on_referral_link", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agents", "browsers", on_update: :cascade, on_delete: :nullify
  add_foreign_key "biovision_component_users", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biovision_component_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "codes", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "ip_addresses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "codes", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "dynamic_pages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "dynamic_pages", "simple_images", on_update: :cascade, on_delete: :nullify
  add_foreign_key "login_attempts", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "login_attempts", "ip_addresses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "login_attempts", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "metric_values", "metrics", on_update: :cascade, on_delete: :cascade
  add_foreign_key "metrics", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "navigation_group_pages", "dynamic_pages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "navigation_group_pages", "navigation_groups", on_update: :cascade, on_delete: :cascade
  add_foreign_key "notifications", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "notifications", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_image_tag_images", "simple_image_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_image_tag_images", "simple_images", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_images", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "simple_images", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_images", "ip_addresses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "simple_images", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "tokens", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "tokens", "ip_addresses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "tokens", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "ip_addresses", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "inviter_id", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "primary_id", on_update: :cascade, on_delete: :nullify
end
