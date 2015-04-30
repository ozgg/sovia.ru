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

ActiveRecord::Schema.define(version: 20150430003924) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agent_requests", force: true do |t|
    t.integer  "agent_id",                   null: false
    t.date     "day",                        null: false
    t.integer  "requests_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agent_requests", ["agent_id"], name: "index_agent_requests_on_agent_id", using: :btree
  add_index "agent_requests", ["day", "agent_id"], name: "index_agent_requests_on_day_and_agent_id", unique: true, using: :btree

  create_table "agents", force: true do |t|
    t.string   "name"
    t.boolean  "is_bot",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agents", ["name"], name: "index_agents_on_name", using: :btree

  create_table "answers", force: true do |t|
    t.integer  "question_id",             null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "upvotes",     default: 0, null: false
    t.integer  "downwotes",   default: 0, null: false
    t.integer  "rating",      default: 0, null: false
    t.text     "body",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "answers", ["agent_id"], name: "index_answers_on_agent_id", using: :btree
  add_index "answers", ["question_id"], name: "index_answers_on_question_id", using: :btree
  add_index "answers", ["user_id"], name: "index_answers_on_user_id", using: :btree

  create_table "codes", force: true do |t|
    t.integer  "user_id"
    t.string   "type",                       null: false
    t.string   "body",                       null: false
    t.string   "payload"
    t.boolean  "activated",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "agent_id"
    t.inet     "ip"
  end

  add_index "codes", ["agent_id"], name: "index_codes_on_agent_id", using: :btree
  add_index "codes", ["body"], name: "index_codes_on_body", unique: true, using: :btree
  add_index "codes", ["user_id"], name: "index_codes_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "entry_id"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.boolean  "is_visible",       default: true, null: false
    t.text     "body",                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.inet     "ip"
    t.integer  "agent_id"
  end

  add_index "comments", ["agent_id"], name: "index_comments_on_agent_id", using: :btree
  add_index "comments", ["entry_id"], name: "index_comments_on_entry_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "deeds", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "goal_id"
  end

  add_index "deeds", ["goal_id"], name: "index_deeds_on_goal_id", using: :btree
  add_index "deeds", ["user_id"], name: "index_deeds_on_user_id", using: :btree

  create_table "dreams", force: true do |t|
    t.integer  "user_id"
    t.integer  "language_id",                          null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "privacy",              default: 0,     null: false
    t.integer  "lucidity",             default: 0,     null: false
    t.integer  "factors",              default: 0,     null: false
    t.boolean  "needs_interpretation", default: false, null: false
    t.integer  "time_of_day"
    t.integer  "comments_count",       default: 0,     null: false
    t.string   "image"
    t.string   "title"
    t.text     "body",                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dreams", ["agent_id"], name: "index_dreams_on_agent_id", using: :btree
  add_index "dreams", ["language_id"], name: "index_dreams_on_language_id", using: :btree
  add_index "dreams", ["user_id"], name: "index_dreams_on_user_id", using: :btree

  create_table "entries", force: true do |t|
    t.integer  "user_id"
    t.string   "type",                       null: false
    t.integer  "privacy",        default: 0, null: false
    t.string   "title"
    t.string   "url_title"
    t.text     "body",                       null: false
    t.integer  "comments_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lucidity",       default: 0
  end

  add_index "entries", ["type", "privacy"], name: "index_entries_on_type_and_privacy", using: :btree
  add_index "entries", ["user_id"], name: "index_entries_on_user_id", using: :btree

  create_table "entry_tags", force: true do |t|
    t.integer "entry_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "entry_tags", ["entry_id", "tag_id"], name: "index_entry_tags_on_entry_id_and_tag_id", unique: true, using: :btree
  add_index "entry_tags", ["entry_id"], name: "index_entry_tags_on_entry_id", using: :btree
  add_index "entry_tags", ["tag_id"], name: "index_entry_tags_on_tag_id", using: :btree

  create_table "fillers", force: true do |t|
    t.integer  "queue",       null: false
    t.integer  "gender"
    t.integer  "language_id", null: false
    t.string   "title"
    t.string   "body",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fillers", ["language_id"], name: "index_fillers_on_language_id", using: :btree

  create_table "goals", force: true do |t|
    t.integer  "user_id"
    t.integer  "status",      default: 0, null: false
    t.string   "name",                    null: false
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "languages", force: true do |t|
    t.string "code", null: false
    t.string "name", null: false
  end

  add_index "languages", ["code"], name: "index_languages_on_code", unique: true, using: :btree

  create_table "networks", force: true do |t|
    t.string   "name",                         null: false
    t.string   "accounts_count", default: "0", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patterns", force: true do |t|
    t.integer  "language_id",             null: false
    t.integer  "dream_count", default: 0, null: false
    t.string   "image"
    t.string   "name",                    null: false
    t.string   "code",                    null: false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "patterns", ["code", "language_id"], name: "index_patterns_on_code_and_language_id", using: :btree
  add_index "patterns", ["dream_count", "language_id"], name: "index_patterns_on_dream_count_and_language_id", using: :btree
  add_index "patterns", ["language_id"], name: "index_patterns_on_language_id", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id",                       null: false
    t.integer  "language_id",                   null: false
    t.integer  "rating",         default: 0,    null: false
    t.integer  "comments_count", default: 0,    null: false
    t.string   "image"
    t.string   "title",                         null: false
    t.text     "lead"
    t.text     "body",                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "upvotes",        default: 0,    null: false
    t.integer  "downvotes",      default: 0,    null: false
    t.inet     "ip"
    t.integer  "agent_id"
    t.boolean  "show_in_list",   default: true, null: false
  end

  add_index "posts", ["agent_id"], name: "index_posts_on_agent_id", using: :btree
  add_index "posts", ["language_id"], name: "index_posts_on_language_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "language_id",               null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "upvotes",       default: 0, null: false
    t.integer  "downvotes",     default: 0, null: false
    t.integer  "rating",        default: 0, null: false
    t.integer  "answers_count", default: 0, null: false
    t.text     "body",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "questions", ["agent_id"], name: "index_questions_on_agent_id", using: :btree
  add_index "questions", ["language_id"], name: "index_questions_on_language_id", using: :btree
  add_index "questions", ["user_id"], name: "index_questions_on_user_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "type",                       null: false
    t.string   "letter",                     null: false
    t.string   "name",                       null: false
    t.string   "canonical_name",             null: false
    t.integer  "entries_count",  default: 0, null: false
    t.integer  "users_count",    default: 0, null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["type", "canonical_name"], name: "index_tags_on_type_and_canonical_name", unique: true, using: :btree
  add_index "tags", ["type", "entries_count"], name: "index_tags_on_type_and_entries_count", using: :btree
  add_index "tags", ["type", "letter"], name: "index_tags_on_type_and_letter", using: :btree

  create_table "user_languages", force: true do |t|
    t.integer "user_id",     null: false
    t.integer "language_id", null: false
  end

  add_index "user_languages", ["language_id"], name: "index_user_languages_on_language_id", using: :btree
  add_index "user_languages", ["user_id"], name: "index_user_languages_on_user_id", using: :btree

  create_table "user_roles", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "role",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_roles", ["user_id", "role"], name: "index_user_roles_on_user_id_and_role", unique: true, using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "user_tags", force: true do |t|
    t.integer "user_id",                   null: false
    t.integer "tag_id",                    null: false
    t.integer "entries_count", default: 0, null: false
    t.text    "description"
  end

  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["user_id", "tag_id"], name: "index_user_tags_on_user_id_and_tag_id", unique: true, using: :btree
  add_index "user_tags", ["user_id"], name: "index_user_tags_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                             null: false
    t.string   "email"
    t.string   "password_digest",                   null: false
    t.string   "avatar"
    t.boolean  "mail_confirmed",    default: false, null: false
    t.boolean  "allow_mail",        default: false, null: false
    t.integer  "entries_count",     default: 0,     null: false
    t.integer  "comments_count",    default: 0,     null: false
    t.integer  "roles_mask",        default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "use_gravatar",      default: false
    t.integer  "gender"
    t.integer  "posts_count",       default: 0,     null: false
    t.integer  "dreams_count",      default: 0,     null: false
    t.integer  "language_id"
    t.inet     "ip"
    t.integer  "agent_id"
    t.boolean  "bot",               default: false, null: false
    t.integer  "questions_count",   default: 0,     null: false
    t.integer  "answers_count",     default: 0,     null: false
    t.integer  "rating",            default: 0,     null: false
    t.integer  "upvotes",           default: 0,     null: false
    t.integer  "downvotes",         default: 0,     null: false
    t.integer  "network",           default: 0,     null: false
    t.string   "name"
    t.string   "screen_name"
    t.datetime "token_expiry"
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "avatar_url_small"
    t.string   "avatar_url_medium"
    t.string   "avatar_url_big"
  end

  add_index "users", ["agent_id"], name: "index_users_on_agent_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["language_id"], name: "index_users_on_language_id", using: :btree
  add_index "users", ["network", "login"], name: "index_users_on_network_and_login", unique: true, using: :btree

end
