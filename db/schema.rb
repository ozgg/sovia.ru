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

ActiveRecord::Schema.define(version: 20150710225624) do

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
    t.integer "agents_count", default: 1,     null: false
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

  create_table "goals", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "status",      null: false
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "goals", ["user_id"], name: "index_goals_on_user_id", using: :btree

  create_table "languages", force: :cascade do |t|
    t.string "code", null: false
    t.string "slug", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "language_id",                    null: false
    t.integer  "user_id",                        null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "rating",         default: 0,     null: false
    t.integer  "upvote_count",   default: 0,     null: false
    t.integer  "downvote_count", default: 0,     null: false
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
  add_index "posts", ["language_id"], name: "index_posts_on_language_id", using: :btree
  add_index "posts", ["show_in_list", "language_id"], name: "index_posts_on_show_in_list_and_language_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.integer  "language_id",             null: false
    t.string   "name",                    null: false
    t.string   "slug",                    null: false
    t.integer  "post_count",  default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "tags", ["language_id"], name: "index_tags_on_language_id", using: :btree
  add_index "tags", ["slug", "language_id"], name: "index_tags_on_slug_and_language_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "role",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "user_roles", ["user_id", "role"], name: "index_user_roles_on_user_id_and_role", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.integer  "language_id",                     null: false
    t.inet     "ip"
    t.integer  "agent_id"
    t.integer  "network",                         null: false
    t.integer  "user_id"
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
  add_index "users", ["language_id"], name: "index_users_on_language_id", using: :btree
  add_index "users", ["uid", "network"], name: "index_users_on_uid_and_network", using: :btree

  add_foreign_key "agents", "browsers"
  add_foreign_key "goals", "users"
  add_foreign_key "posts", "agents"
  add_foreign_key "posts", "languages"
  add_foreign_key "posts", "users"
  add_foreign_key "tags", "languages"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "agents"
  add_foreign_key "users", "languages"
end
