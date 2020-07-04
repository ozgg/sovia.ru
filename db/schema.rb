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

ActiveRecord::Schema.define(version: 2020_07_04_214503) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gin"
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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "agents", comment: "User agent", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "browser_id"
    t.boolean "bot", default: false, null: false
    t.boolean "mobile", default: false, null: false
    t.boolean "active", default: true, null: false
    t.string "name", null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id"
    t.index ["name"], name: "index_agents_on_name"
  end

  create_table "biovision_component_users", comment: "User privileges in component", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "administrator", default: false, null: false
    t.jsonb "data", default: {}, null: false
    t.index ["biovision_component_id"], name: "index_biovision_component_users_on_biovision_component_id"
    t.index ["user_id"], name: "index_biovision_component_users_on_user_id"
  end

  create_table "biovision_components", comment: "Biovision component", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.jsonb "settings", default: {}, null: false
    t.jsonb "parameters", default: {}, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "active", default: true, null: false
    t.index ["slug"], name: "index_biovision_components_on_slug", unique: true
  end

  create_table "browsers", comment: "Browser for grouping user agents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "bot", default: false, null: false
    t.boolean "mobile", default: false, null: false
    t.boolean "active", default: true, null: false
    t.integer "agents_count", default: 0, null: false
    t.string "name", null: false
    t.index ["name"], name: "index_browsers_on_name"
  end

  create_table "code_types", comment: "Type of code", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
  end

  create_table "codes", comment: "Code for users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "code_type_id", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.integer "quantity", limit: 2, default: 1, null: false
    t.string "body", null: false
    t.string "payload"
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_codes_on_agent_id"
    t.index ["body", "code_type_id", "quantity"], name: "index_codes_on_body_and_code_type_id_and_quantity"
    t.index ["code_type_id"], name: "index_codes_on_code_type_id"
    t.index ["data"], name: "index_codes_on_data", using: :gin
    t.index ["user_id"], name: "index_codes_on_user_id"
  end

  create_table "comments", id: :serial, comment: "Comment for commentable item", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "user_id"
    t.integer "agent_id"
    t.inet "ip"
    t.boolean "visible", default: true, null: false
    t.boolean "locked", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.boolean "spam", default: false, null: false
    t.boolean "approved", default: true, null: false
    t.integer "commentable_id", null: false
    t.string "commentable_type", null: false
    t.string "author_name"
    t.string "author_email"
    t.text "body", null: false
    t.jsonb "data", default: {}, null: false
    t.uuid "uuid"
    t.index "to_tsvector('russian'::regconfig, body)", name: "comments_search_idx", using: :gin
    t.index ["agent_id"], name: "index_comments_on_agent_id"
    t.index ["approved", "agent_id", "ip"], name: "index_comments_on_approved_and_agent_id_and_ip"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["data"], name: "index_comments_on_data", using: :gin
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "dreambook_queries", comment: "Dreambook search query", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "body"
    t.index ["agent_id"], name: "index_dreambook_queries_on_agent_id"
    t.index ["user_id"], name: "index_dreambook_queries_on_user_id"
  end

  create_table "dreams", comment: "Dream", force: :cascade do |t|
    t.uuid "uuid"
    t.bigint "user_id"
    t.bigint "sleep_place_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.integer "lucidity", limit: 2, default: 0, null: false
    t.integer "privacy", limit: 2, default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.string "title"
    t.text "body", null: false
    t.jsonb "data", default: {}, null: false
    t.boolean "interpreted", default: false, null: false
    t.index "date_trunc('month'::text, created_at)", name: "dreams_created_month_idx"
    t.index "dreams_tsvector((title)::text, body)", name: "dreams_search_idx", using: :gin
    t.index ["agent_id"], name: "index_dreams_on_agent_id"
    t.index ["sleep_place_id"], name: "index_dreams_on_sleep_place_id"
    t.index ["user_id"], name: "index_dreams_on_user_id"
    t.index ["uuid"], name: "index_dreams_on_uuid"
    t.index ["visible", "privacy"], name: "index_dreams_on_visible_and_privacy"
  end

  create_table "editable_pages", comment: "Editable page", force: :cascade do |t|
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
    t.text "parsed_body"
    t.index ["language_id"], name: "index_editable_pages_on_language_id"
  end

  create_table "editorial_member_post_types", comment: "Available post type for editorial member", force: :cascade do |t|
    t.bigint "editorial_member_id", null: false
    t.bigint "post_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["editorial_member_id"], name: "index_editorial_member_post_types_on_editorial_member_id"
    t.index ["post_type_id"], name: "index_editorial_member_post_types_on_post_type_id"
  end

  create_table "editorial_members", comment: "Editorial member", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.string "title"
    t.text "lead"
    t.text "about"
    t.index ["user_id"], name: "index_editorial_members_on_user_id"
  end

  create_table "featured_posts", force: :cascade do |t|
    t.bigint "language_id", null: false
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.index ["language_id"], name: "index_featured_posts_on_language_id"
    t.index ["post_id"], name: "index_featured_posts_on_post_id"
  end

  create_table "feedback_requests", comment: "Feedback request", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.boolean "processed", default: false, null: false
    t.boolean "consent", default: false, null: false
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "image"
    t.text "comment"
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_feedback_requests_on_agent_id"
    t.index ["language_id"], name: "index_feedback_requests_on_language_id"
    t.index ["user_id"], name: "index_feedback_requests_on_user_id"
  end

  create_table "fillers", comment: "Filler for dream", force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.text "body", null: false
    t.index ["user_id"], name: "index_fillers_on_user_id"
  end

  create_table "foreign_sites", comment: "Foreign site for OAuth", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.integer "foreign_users_count", default: 0, null: false
  end

  create_table "foreign_users", comment: "User from foreign site", force: :cascade do |t|
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

  create_table "interpretation_messages", comment: "Messages in interpretation requests", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "interpretation_id", null: false
    t.boolean "from_user", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body", null: false
    t.index ["interpretation_id"], name: "index_interpretation_messages_on_interpretation_id"
    t.index ["uuid"], name: "index_interpretation_messages_on_uuid", unique: true
  end

  create_table "interpretations", comment: "Interpretation requests", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "user_id", null: false
    t.bigint "dream_id"
    t.boolean "solved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "body"
    t.index ["dream_id"], name: "index_interpretations_on_dream_id"
    t.index ["user_id"], name: "index_interpretations_on_user_id"
    t.index ["uuid"], name: "index_interpretations_on_uuid", unique: true
  end

  create_table "languages", comment: "Language l10n, i18n, etc.", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.integer "users_count", default: 0, null: false
    t.string "slug", null: false
    t.string "code", null: false
  end

  create_table "login_attempts", comment: "Failed login attempt", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.string "password", default: "", null: false
    t.index ["agent_id"], name: "index_login_attempts_on_agent_id"
    t.index ["user_id"], name: "index_login_attempts_on_user_id"
  end

  create_table "media_files", comment: "Media file", force: :cascade do |t|
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

  create_table "media_folders", comment: "Media folder", force: :cascade do |t|
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

  create_table "metric_values", comment: "Single metric value", force: :cascade do |t|
    t.bigint "metric_id", null: false
    t.datetime "time", null: false
    t.integer "quantity", default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx"
    t.index ["metric_id"], name: "index_metric_values_on_metric_id"
  end

  create_table "metrics", comment: "Metric for component", force: :cascade do |t|
    t.bigint "biovision_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "incremental", default: false, null: false
    t.boolean "start_with_zero", default: false, null: false
    t.boolean "show_on_dashboard", default: true, null: false
    t.integer "default_period", limit: 2, default: 7, null: false
    t.integer "value", default: 0, null: false
    t.integer "previous_value", default: 0, null: false
    t.string "name", null: false
    t.index ["biovision_component_id"], name: "index_metrics_on_biovision_component_id"
  end

  create_table "notifications", comment: "Component notifications", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id", null: false
    t.boolean "email_sent", default: false, null: false
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["biovision_component_id"], name: "index_notifications_on_biovision_component_id"
    t.index ["data"], name: "index_notifications_on_data", using: :gin
    t.index ["user_id"], name: "index_notifications_on_user_id"
    t.index ["uuid"], name: "index_notifications_on_uuid", unique: true
  end

  create_table "patterns", comment: "Dreambook pattern", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "summary"
    t.text "description"
    t.boolean "processed", default: false, null: false
    t.jsonb "data", default: {}, null: false
    t.index "patterns_tsvector((name)::text, (summary)::text, description)", name: "patterns_search_idx", using: :gin
    t.index ["name"], name: "index_patterns_on_name", unique: true
  end

  create_table "paypal_events", comment: "PayPal webhook events", force: :cascade do |t|
    t.bigint "paypal_invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["data"], name: "index_paypal_events_on_data", using: :gin
    t.index ["paypal_invoice_id"], name: "index_paypal_events_on_paypal_invoice_id"
  end

  create_table "paypal_invoices", comment: "PayPal invoices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "uuid", null: false
    t.boolean "paid", default: false, null: false
    t.integer "amount", null: false
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_paypal_invoices_on_agent_id"
    t.index ["data"], name: "index_paypal_invoices_on_data", using: :gin
    t.index ["user_id"], name: "index_paypal_invoices_on_user_id"
    t.index ["uuid"], name: "index_paypal_invoices_on_uuid", unique: true
  end

  create_table "pending_patterns", comment: "Pending pattern for interpretation", force: :cascade do |t|
    t.bigint "pattern_id"
    t.boolean "processed", default: false, null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pending_patterns_on_name"
    t.index ["pattern_id"], name: "index_pending_patterns_on_pattern_id"
  end

  create_table "post_attachments", comment: "Attachment for post", force: :cascade do |t|
    t.bigint "post_id"
    t.uuid "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "file"
    t.index ["post_id"], name: "index_post_attachments_on_post_id"
  end

  create_table "post_categories", comment: "Post category", force: :cascade do |t|
    t.bigint "post_type_id", null: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.integer "posts_count", default: 0, null: false
    t.boolean "locked", default: false, null: false
    t.boolean "visible", default: true, null: false
    t.boolean "deleted", default: false, null: false
    t.string "name", null: false
    t.string "nav_text"
    t.string "slug", null: false
    t.string "long_slug", null: false
    t.string "meta_description"
    t.string "parents_cache", default: "", null: false
    t.integer "children_cache", default: [], null: false, array: true
    t.jsonb "data", default: {}, null: false
    t.index ["post_type_id"], name: "index_post_categories_on_post_type_id"
  end

  create_table "post_group_categories", comment: "Post category in group", force: :cascade do |t|
    t.bigint "post_group_id", null: false
    t.bigint "post_category_id", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_category_id"], name: "index_post_group_categories_on_post_category_id"
    t.index ["post_group_id"], name: "index_post_group_categories_on_post_group_id"
  end

  create_table "post_group_tags", comment: "Post tag in group", force: :cascade do |t|
    t.bigint "post_group_id", null: false
    t.bigint "post_tag_id", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_group_id"], name: "index_post_group_tags_on_post_group_id"
    t.index ["post_tag_id"], name: "index_post_group_tags_on_post_tag_id"
  end

  create_table "post_groups", comment: "Group of post categories and tags", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "name"
    t.string "nav_text"
  end

  create_table "post_illustrations", comment: "Inline post illustration", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["agent_id"], name: "index_post_illustrations_on_agent_id"
    t.index ["user_id"], name: "index_post_illustrations_on_user_id"
  end

  create_table "post_images", comment: "Image in post gallery", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.uuid "uuid"
    t.string "image"
    t.string "image_alt_text"
    t.string "caption"
    t.string "source_name"
    t.string "source_link"
    t.text "description"
    t.index ["post_id"], name: "index_post_images_on_post_id"
  end

  create_table "post_layouts", comment: "Post layout", force: :cascade do |t|
    t.integer "posts_count", default: 0, null: false
    t.string "slug"
    t.string "name"
  end

  create_table "post_links", comment: "Link between posts", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.integer "other_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.index ["post_id"], name: "index_post_links_on_post_id"
  end

  create_table "post_notes", comment: "Footnote for post", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.text "text", null: false
    t.index ["post_id"], name: "index_post_notes_on_post_id"
  end

  create_table "post_post_categories", comment: "Post in post category", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "post_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_category_id"], name: "index_post_post_categories_on_post_category_id"
    t.index ["post_id"], name: "index_post_post_categories_on_post_id"
  end

  create_table "post_post_tags", comment: "Link between post and tag", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "post_tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_post_tags_on_post_id"
    t.index ["post_tag_id"], name: "index_post_post_tags_on_post_tag_id"
  end

  create_table "post_references", comment: "Reference in post body", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "priority", limit: 2, default: 1, null: false
    t.string "authors"
    t.string "title", null: false
    t.string "url"
    t.string "publishing_info"
    t.index ["post_id"], name: "index_post_references_on_post_id"
  end

  create_table "post_tags", comment: "Post tag", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "post_type_id", null: false
    t.integer "posts_count", default: 0, null: false
    t.string "name"
    t.string "slug"
    t.index ["post_type_id"], name: "index_post_tags_on_post_type_id"
    t.index ["slug"], name: "index_post_tags_on_slug"
  end

  create_table "post_translations", comment: "Post translation", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "language_id", null: false
    t.integer "translated_post_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["language_id"], name: "index_post_translations_on_language_id"
    t.index ["post_id"], name: "index_post_translations_on_post_id"
  end

  create_table "post_types", comment: "Post type", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.integer "posts_count", default: 0, null: false
    t.integer "category_depth", limit: 2, default: 0
    t.string "name", null: false
    t.string "slug", null: false
    t.string "url_part", null: false
    t.string "default_category_name"
    t.index ["name"], name: "index_post_types_on_name", unique: true
    t.index ["slug"], name: "index_post_types_on_slug", unique: true
  end

  create_table "post_zen_categories", comment: "Link between post and Yandex.zen category", force: :cascade do |t|
    t.bigint "post_id", null: false
    t.bigint "zen_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_post_zen_categories_on_post_id"
    t.index ["zen_category_id"], name: "index_post_zen_categories_on_zen_category_id"
  end

  create_table "posts", comment: "Post", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "post_type_id", null: false
    t.bigint "language_id"
    t.integer "region_id"
    t.integer "original_post_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.boolean "locked", default: false, null: false
    t.boolean "deleted", default: false, null: false
    t.boolean "approved", default: true, null: false
    t.boolean "show_owner", default: true, null: false
    t.boolean "allow_comments", default: true, null: false
    t.boolean "allow_votes", default: true, null: false
    t.boolean "translation", default: false, null: false
    t.boolean "explicit", default: false, null: false
    t.boolean "spam", default: false, null: false
    t.boolean "avoid_parsing", default: false, null: false
    t.float "rating", default: 0.0, null: false
    t.integer "privacy", limit: 2, default: 0
    t.integer "comments_count", default: 0, null: false
    t.integer "view_count", default: 0, null: false
    t.integer "time_required", limit: 2
    t.datetime "publication_time"
    t.uuid "uuid", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.string "image"
    t.string "image_alt_text"
    t.string "image_name"
    t.string "image_source_name"
    t.string "image_source_link"
    t.string "original_title"
    t.string "source_name"
    t.string "source_link"
    t.string "meta_title"
    t.string "meta_keywords"
    t.string "meta_description"
    t.string "author_name"
    t.string "author_title"
    t.string "author_url"
    t.string "translator_name"
    t.text "lead"
    t.text "body", null: false
    t.text "parsed_body"
    t.string "tags_cache", default: [], null: false, array: true
    t.jsonb "data", default: {}, null: false
    t.index "date_trunc('month'::text, created_at), post_type_id, user_id", name: "posts_created_at_month_idx"
    t.index "date_trunc('month'::text, publication_time), post_type_id, user_id", name: "posts_pubdate_month_idx"
    t.index "posts_tsvector((title)::text, lead, body)", name: "posts_search_idx", using: :gin
    t.index ["agent_id"], name: "index_posts_on_agent_id"
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["data"], name: "index_posts_on_data", using: :gin
    t.index ["language_id"], name: "index_posts_on_language_id"
    t.index ["post_type_id"], name: "index_posts_on_post_type_id"
    t.index ["slug"], name: "index_posts_on_slug"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "privilege_group_privileges", comment: "Privilege in group", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "privilege_group_id", null: false
    t.bigint "privilege_id", null: false
    t.boolean "deletable", default: true, null: false
    t.index ["privilege_group_id"], name: "index_privilege_group_privileges_on_privilege_group_id"
    t.index ["privilege_id"], name: "index_privilege_group_privileges_on_privilege_id"
  end

  create_table "privilege_groups", comment: "Privilege group", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletable", default: true, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "description", default: "", null: false
    t.index ["slug"], name: "index_privilege_groups_on_slug", unique: true
  end

  create_table "privileges", comment: "Privilege", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
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

  create_table "robokassa_invoices", comment: "Robokassa invoices", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", limit: 2, default: 0, null: false
    t.integer "price"
    t.string "email"
    t.jsonb "data", default: {}, null: false
    t.index ["agent_id"], name: "index_robokassa_invoices_on_agent_id"
    t.index ["data"], name: "index_robokassa_invoices_on_data", using: :gin
    t.index ["user_id"], name: "index_robokassa_invoices_on_user_id"
    t.index ["uuid"], name: "index_robokassa_invoices_on_uuid", unique: true
  end

  create_table "services", comment: "Paid services", force: :cascade do |t|
    t.integer "priority", limit: 2, default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.boolean "visible", default: true, null: false
    t.boolean "highlighted", default: false, null: false
    t.integer "price", null: false
    t.integer "old_price"
    t.integer "users_count", default: 0, null: false
    t.integer "duration", default: 0, null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.string "image"
    t.string "lead"
    t.text "description"
    t.jsonb "data", default: {}, null: false
  end

  create_table "simple_blocks", comment: "Simple editable block", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible", default: true, null: false
    t.boolean "background_image", default: false, null: false
    t.string "slug", null: false
    t.string "name"
    t.string "image"
    t.string "image_alt_text"
    t.text "body"
    t.index ["name"], name: "index_simple_blocks_on_name"
    t.index ["slug"], name: "index_simple_blocks_on_slug"
  end

  create_table "simple_image_tag_images", comment: "Link between simple image and tag", force: :cascade do |t|
    t.bigint "simple_image_id", null: false
    t.bigint "simple_image_tag_id", null: false
    t.index ["simple_image_id"], name: "index_simple_image_tag_images_on_simple_image_id"
    t.index ["simple_image_tag_id"], name: "index_simple_image_tag_images_on_simple_image_tag_id"
  end

  create_table "simple_image_tags", comment: "Tag for tagging simple image", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "simple_images_count", default: 0, null: false
    t.index ["name"], name: "index_simple_image_tags_on_name"
    t.index ["simple_images_count"], name: "index_simple_image_tags_on_simple_images_count"
  end

  create_table "simple_images", comment: "Simple image", force: :cascade do |t|
    t.bigint "biovision_component_id", null: false
    t.bigint "user_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.uuid "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "image_alt_text"
    t.string "caption"
    t.string "source_name"
    t.string "source_link"
    t.jsonb "data", default: {}, null: false
    t.integer "object_count", default: 0, null: false
    t.index ["agent_id"], name: "index_simple_images_on_agent_id"
    t.index ["biovision_component_id"], name: "index_simple_images_on_biovision_component_id"
    t.index ["user_id"], name: "index_simple_images_on_user_id"
  end

  create_table "sleep_places", comment: "Sleep place", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "dreams_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["user_id"], name: "index_sleep_places_on_user_id"
  end

  create_table "tokens", comment: "Authentication token", force: :cascade do |t|
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

  create_table "user_bans", comment: "Personal ban lists for users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "other_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_bans_on_user_id"
  end

  create_table "user_languages", comment: "Language for user", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "language_id", null: false
    t.index ["language_id"], name: "index_user_languages_on_language_id"
    t.index ["user_id"], name: "index_user_languages_on_user_id"
  end

  create_table "user_messages", comment: "Messages between users", force: :cascade do |t|
    t.uuid "uuid", null: false
    t.integer "sender_id", null: false
    t.integer "receiver_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false, null: false
    t.boolean "sender_deleted", default: false, null: false
    t.boolean "receiver_deleted", default: false, null: false
    t.text "body"
    t.jsonb "data", default: {}, null: false
    t.bigint "agent_id"
    t.inet "ip"
    t.index ["agent_id"], name: "index_user_messages_on_agent_id"
    t.index ["uuid"], name: "index_user_messages_on_uuid", unique: true
  end

  create_table "user_privileges", comment: "Privilege for user", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.bigint "privilege_id", null: false
    t.index ["privilege_id"], name: "index_user_privileges_on_privilege_id"
    t.index ["user_id"], name: "index_user_privileges_on_user_id"
  end

  create_table "user_services", comment: "Purchased services", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 1, null: false
    t.date "end_date"
    t.jsonb "data", default: {}, null: false
    t.index ["service_id"], name: "index_user_services_on_service_id"
    t.index ["user_id"], name: "index_user_services_on_user_id"
  end

  create_table "user_subscriptions", comment: "User-to-user subscriptions", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "followee_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", comment: "User", force: :cascade do |t|
    t.uuid "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "language_id"
    t.bigint "agent_id"
    t.inet "ip"
    t.integer "inviter_id"
    t.integer "native_id"
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
    t.jsonb "data", default: {"profile"=>{}}, null: false
    t.index ["agent_id"], name: "index_users_on_agent_id"
    t.index ["data"], name: "index_users_on_data", using: :gin
    t.index ["email"], name: "index_users_on_email"
    t.index ["language_id"], name: "index_users_on_language_id"
    t.index ["referral_link"], name: "index_users_on_referral_link"
    t.index ["screen_name"], name: "index_users_on_screen_name"
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  create_table "zen_categories", comment: "Category for Yandex.zen", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.integer "posts_count", default: 0, null: false
    t.index ["name"], name: "index_zen_categories_on_name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "agents", "browsers", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biovision_component_users", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "biovision_component_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "codes", "code_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "codes", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "comments", "comments", column: "parent_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "comments", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "dreambook_queries", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreambook_queries", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreams", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreams", "sleep_places", on_update: :cascade, on_delete: :nullify
  add_foreign_key "dreams", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editable_pages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editorial_member_post_types", "editorial_members", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editorial_member_post_types", "post_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "editorial_members", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "featured_posts", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "featured_posts", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "feedback_requests", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "feedback_requests", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "feedback_requests", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "fillers", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "foreign_users", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "foreign_users", "foreign_sites", on_update: :cascade, on_delete: :cascade
  add_foreign_key "foreign_users", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "interpretation_messages", "interpretations", on_update: :cascade, on_delete: :nullify
  add_foreign_key "interpretations", "dreams", on_update: :cascade, on_delete: :nullify
  add_foreign_key "interpretations", "users", on_update: :cascade, on_delete: :cascade
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
  add_foreign_key "notifications", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "notifications", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "paypal_events", "paypal_invoices", on_update: :cascade, on_delete: :nullify
  add_foreign_key "paypal_invoices", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "paypal_invoices", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "pending_patterns", "patterns", on_update: :cascade, on_delete: :nullify
  add_foreign_key "post_attachments", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_categories", "post_categories", column: "parent_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_categories", "post_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_group_categories", "post_categories", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_group_categories", "post_groups", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_group_tags", "post_groups", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_group_tags", "post_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_illustrations", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "post_illustrations", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "post_images", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_links", "posts", column: "other_post_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_links", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_notes", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_post_categories", "post_categories", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_post_categories", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_post_tags", "post_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_post_tags", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_references", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_tags", "post_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_translations", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_translations", "posts", column: "translated_post_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_translations", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_zen_categories", "posts", on_update: :cascade, on_delete: :cascade
  add_foreign_key "post_zen_categories", "zen_categories", on_update: :cascade, on_delete: :cascade
  add_foreign_key "posts", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "posts", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "posts", "post_types", on_update: :cascade, on_delete: :cascade
  add_foreign_key "posts", "posts", column: "original_post_id", on_update: :cascade, on_delete: :nullify
  add_foreign_key "posts", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privilege_group_privileges", "privilege_groups", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privilege_group_privileges", "privileges", on_update: :cascade, on_delete: :cascade
  add_foreign_key "privileges", "privileges", column: "parent_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "robokassa_invoices", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "robokassa_invoices", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "simple_image_tag_images", "simple_image_tags", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_image_tag_images", "simple_images", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_images", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "simple_images", "biovision_components", on_update: :cascade, on_delete: :cascade
  add_foreign_key "simple_images", "users", on_update: :cascade, on_delete: :nullify
  add_foreign_key "sleep_places", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "tokens", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "tokens", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_bans", "users", column: "other_user_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_bans", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "languages", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_languages", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_messages", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "user_messages", "users", column: "receiver_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_messages", "users", column: "sender_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_privileges", "privileges", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_privileges", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_services", "services", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_services", "users", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_subscriptions", "users", column: "followee_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "user_subscriptions", "users", column: "follower_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "users", "agents", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "languages", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "inviter_id", on_update: :cascade, on_delete: :nullify
  add_foreign_key "users", "users", column: "native_id", on_update: :cascade, on_delete: :nullify
end
