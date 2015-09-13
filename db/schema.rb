# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150829182854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.integer  "browser_id"
    t.boolean  "bot",        default: false, null: false
    t.boolean  "mobile",     default: false, null: false
    t.string   "name",                       null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "agents", ["browser_id"], name: "index_agents_on_browser_id", using: :btree
  add_index "agents", ["name"], name: "index_agents_on_name", using: :btree

  create_table "browsers", force: :cascade do |t|
    t.string  "name",                         null: false
    t.boolean "bot",          default: false, null: false
    t.boolean "mobile",       default: false, null: false
    t.integer "agents_count", default: 0,     null: false
  end

  add_index "browsers", ["name"], name: "index_browsers_on_name", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "secret",                    null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "clients", ["name"], name: "index_clients_on_name", using: :btree

  create_table "codes", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "category",                   null: false
    t.boolean  "activated",  default: false, null: false
    t.string   "body",                       null: false
    t.string   "payload"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "codes", ["agent_id"], name: "index_codes_on_agent_id", using: :btree
  add_index "codes", ["user_id"], name: "index_codes_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "parent_id"
    t.integer  "commentable_id",                   null: false
    t.string   "commentable_type",                 null: false
    t.boolean  "best",             default: false, null: false
    t.boolean  "visible",          default: true,  null: false
    t.integer  "rating",           default: 0,     null: false
    t.integer  "upvote_count",     default: 0,     null: false
    t.integer  "downvote_count",   default: 0,     null: false
    t.text     "body",                             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "comments", ["agent_id"], name: "index_comments_on_agent_id", using: :btree
  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "deeds", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "goal_id"
    t.string   "essence",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "deeds", ["goal_id"], name: "index_deeds_on_goal_id", using: :btree
  add_index "deeds", ["user_id"], name: "index_deeds_on_user_id", using: :btree

  create_table "dream_factors", force: :cascade do |t|
    t.integer "dream_id", null: false
    t.integer "factor",   null: false
  end

  add_index "dream_factors", ["dream_id"], name: "index_dream_factors_on_dream_id", using: :btree

  create_table "dream_grains", force: :cascade do |t|
    t.integer "dream_id", null: false
    t.integer "grain_id", null: false
  end

  add_index "dream_grains", ["dream_id", "grain_id"], name: "index_dream_grains_on_dream_id_and_grain_id", using: :btree
  add_index "dream_grains", ["dream_id"], name: "index_dream_grains_on_dream_id", using: :btree
  add_index "dream_grains", ["grain_id"], name: "index_dream_grains_on_grain_id", using: :btree

  create_table "dream_patterns", force: :cascade do |t|
    t.integer "dream_id",   null: false
    t.integer "pattern_id", null: false
    t.integer "status",     null: false
  end

  add_index "dream_patterns", ["dream_id", "pattern_id"], name: "index_dream_patterns_on_dream_id_and_pattern_id", using: :btree
  add_index "dream_patterns", ["dream_id"], name: "index_dream_patterns_on_dream_id", using: :btree
  add_index "dream_patterns", ["pattern_id"], name: "index_dream_patterns_on_pattern_id", using: :btree

  create_table "dreams", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "privacy",                              null: false
    t.integer  "lucidity",             default: 0,     null: false
    t.integer  "mood",                 default: 0,     null: false
    t.integer  "azimuth"
    t.integer  "body_position"
    t.boolean  "needs_interpretation", default: false, null: false
    t.boolean  "interpretation_given", default: false, null: false
    t.integer  "time_of_day"
    t.integer  "comments_count",       default: 0,     null: false
    t.boolean  "show_image",           default: true,  null: false
    t.integer  "rating",               default: 0,     null: false
    t.integer  "upvote_count",         default: 0,     null: false
    t.integer  "downvote_count",       default: 0,     null: false
    t.string   "image"
    t.string   "title"
    t.text     "body",                                 null: false
    t.string   "patterns_cache",       default: [],    null: false, array: true
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "dreams", ["agent_id"], name: "index_dreams_on_agent_id", using: :btree
  add_index "dreams", ["place_id"], name: "index_dreams_on_place_id", using: :btree
  add_index "dreams", ["privacy"], name: "index_dreams_on_privacy", using: :btree
  add_index "dreams", ["user_id"], name: "index_dreams_on_user_id", using: :btree

  create_table "goals", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "status",      null: false
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "grains", force: :cascade do |t|
    t.integer  "user_id",                 null: false
    t.integer  "pattern_id"
    t.integer  "dream_count", default: 0, null: false
    t.integer  "category"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "image"
    t.string   "name",                    null: false
    t.string   "slug",                    null: false
    t.text     "description"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "grains", ["pattern_id"], name: "index_grains_on_pattern_id", using: :btree
  add_index "grains", ["slug", "user_id"], name: "index_grains_on_slug_and_user_id", using: :btree
  add_index "grains", ["user_id"], name: "index_grains_on_user_id", using: :btree

  create_table "pattern_links", force: :cascade do |t|
    t.integer "pattern_id", null: false
    t.integer "target_id",  null: false
    t.integer "category",   null: false
  end

  add_index "pattern_links", ["pattern_id", "target_id", "category"], name: "index_pattern_links_on_pattern_id_and_target_id_and_category", using: :btree
  add_index "pattern_links", ["pattern_id"], name: "index_pattern_links_on_pattern_id", using: :btree

  create_table "patterns", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "dream_count",    default: 0, null: false
    t.integer  "comments_count", default: 0, null: false
    t.integer  "rating",         default: 0, null: false
    t.integer  "upvote_count",   default: 0, null: false
    t.integer  "downvote_count", default: 0, null: false
    t.string   "name",                       null: false
    t.string   "slug",                       null: false
    t.string   "image"
    t.text     "description"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "patterns", ["agent_id"], name: "index_patterns_on_agent_id", using: :btree
  add_index "patterns", ["slug"], name: "index_patterns_on_slug", using: :btree
  add_index "patterns", ["user_id"], name: "index_patterns_on_user_id", using: :btree

  create_table "places", force: :cascade do |t|
    t.integer  "user_id",                  null: false
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "azimuth"
    t.integer  "dreams_count", default: 0, null: false
    t.string   "name",                     null: false
    t.string   "image"
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "places", ["user_id"], name: "index_places_on_user_id", using: :btree

  create_table "post_tags", force: :cascade do |t|
    t.integer  "post_id",    null: false
    t.integer  "tag_id",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "post_tags", ["post_id"], name: "index_post_tags_on_post_id", using: :btree
  add_index "post_tags", ["tag_id"], name: "index_post_tags_on_tag_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",                        null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "rating",         default: 0,     null: false
    t.integer  "upvote_count",   default: 0,     null: false
    t.integer  "downvote_count", default: 0,     null: false
    t.integer  "comments_count", default: 0,     null: false
    t.boolean  "show_in_list",   default: false, null: false
    t.string   "title",                          null: false
    t.string   "image"
    t.string   "lead",                           null: false
    t.text     "body",                           null: false
    t.string   "tags_cache",     default: [],    null: false, array: true
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "posts", ["agent_id"], name: "index_posts_on_agent_id", using: :btree
  add_index "posts", ["show_in_list"], name: "index_posts_on_show_in_list", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "rating",         default: 0,     null: false
    t.integer  "upvote_count",   default: 0,     null: false
    t.integer  "downvote_count", default: 0,     null: false
    t.integer  "comments_count", default: 0,     null: false
    t.boolean  "answered",       default: false, null: false
    t.text     "body",                           null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "questions", ["agent_id"], name: "index_questions_on_agent_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "side_notes", force: :cascade do |t|
    t.integer  "user_id",                        null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "active",         default: false, null: false
    t.integer  "rating",         default: 0,     null: false
    t.integer  "upvote_count",   default: 0,     null: false
    t.integer  "downvote_count", default: 0,     null: false
    t.integer  "comments_count", default: 0,     null: false
    t.string   "image"
    t.string   "link",                           null: false
    t.string   "title",                          null: false
    t.text     "body"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "side_notes", ["agent_id"], name: "index_side_notes_on_agent_id", using: :btree
  add_index "side_notes", ["user_id"], name: "index_side_notes_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name",                   null: false
    t.string   "slug",                   null: false
    t.integer  "post_count", default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.integer  "client_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "active",     default: true, null: false
    t.string   "token",                     null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "tokens", ["agent_id"], name: "index_tokens_on_agent_id", using: :btree
  add_index "tokens", ["client_id"], name: "index_tokens_on_client_id", using: :btree
  add_index "tokens", ["token"], name: "index_tokens_on_token", unique: true, using: :btree
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "role",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["user_id", "role"], name: "index_user_roles_on_user_id_and_role", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "network",                         null: false
    t.integer  "user_id"
    t.integer  "invitee_id"
    t.string   "uid",                             null: false
    t.string   "password_digest"
    t.string   "email"
    t.string   "screen_name"
    t.string   "name"
    t.string   "image"
    t.integer  "rating",          default: 0,     null: false
    t.integer  "upvote_count",    default: 0,     null: false
    t.integer  "downvote_count",  default: 0,     null: false
    t.integer  "posts_count",     default: 0,     null: false
    t.integer  "dreams_count",    default: 0,     null: false
    t.integer  "questions_count", default: 0,     null: false
    t.integer  "comments_count",  default: 0,     null: false
    t.integer  "gender"
    t.boolean  "bot",             default: false, null: false
    t.boolean  "allow_login",     default: true,  null: false
    t.boolean  "email_confirmed", default: false, null: false
    t.boolean  "allow_mail",      default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["agent_id"], name: "index_users_on_agent_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["uid", "network"], name: "index_users_on_uid_and_network", using: :btree

  create_table "violations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "agent_id",   null: false
    t.inet     "ip",         null: false
    t.integer  "category",   null: false
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "violations", ["agent_id"], name: "index_violations_on_agent_id", using: :btree
  add_index "violations", ["user_id"], name: "index_violations_on_user_id", using: :btree

  add_foreign_key "agents", "browsers"
  add_foreign_key "codes", "agents"
  add_foreign_key "codes", "users"
  add_foreign_key "comments", "agents"
  add_foreign_key "comments", "users"
  add_foreign_key "deeds", "goals"
  add_foreign_key "deeds", "users"
  add_foreign_key "dream_factors", "dreams"
  add_foreign_key "dream_grains", "dreams"
  add_foreign_key "dream_grains", "grains"
  add_foreign_key "dream_patterns", "dreams"
  add_foreign_key "dream_patterns", "patterns"
  add_foreign_key "dreams", "agents"
  add_foreign_key "dreams", "places"
  add_foreign_key "dreams", "users"
  add_foreign_key "goals", "users"
  add_foreign_key "grains", "patterns"
  add_foreign_key "grains", "users"
  add_foreign_key "pattern_links", "patterns"
  add_foreign_key "patterns", "agents"
  add_foreign_key "patterns", "users"
  add_foreign_key "places", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "agents"
  add_foreign_key "posts", "users"
  add_foreign_key "questions", "agents"
  add_foreign_key "questions", "users"
  add_foreign_key "side_notes", "agents"
  add_foreign_key "side_notes", "users"
  add_foreign_key "tokens", "agents"
  add_foreign_key "tokens", "clients"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "agents"
  add_foreign_key "violations", "agents"
  add_foreign_key "violations", "users"
end
