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

ActiveRecord::Schema.define(version: 20160402230955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "browsers", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "agents_count", default: 0,     null: false
    t.boolean  "bot",          default: false, null: false
    t.boolean  "mobile",       default: false, null: false
    t.string   "name",                         null: false
  end

  add_index "browsers", ["name"], name: "index_browsers_on_name", using: :btree

  create_table "codes", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id",                          null: false
    t.integer  "category",   limit: 2,             null: false
    t.integer  "quantity",   limit: 2, default: 1, null: false
    t.string   "body",                             null: false
    t.string   "payload"
  end

  add_index "codes", ["user_id"], name: "index_codes_on_user_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id",                   null: false
    t.inet     "ip"
    t.boolean  "active",     default: true, null: false
    t.string   "token",                     null: false
  end

  add_index "tokens", ["token"], name: "index_tokens_on_token", unique: true, using: :btree
  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id",           null: false
    t.integer "role",    limit: 2, null: false
  end

  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.inet     "ip"
    t.integer  "network",         limit: 2,                 null: false
    t.string   "slug",                                      null: false
    t.integer  "gender",          limit: 2
    t.boolean  "deleted",                   default: false, null: false
    t.boolean  "bot",                       default: false, null: false
    t.boolean  "allow_login",               default: true,  null: false
    t.boolean  "email_confirmed",           default: false, null: false
    t.boolean  "allow_mail",                default: true,  null: false
    t.datetime "last_seen"
    t.integer  "dreams_count",              default: 0,     null: false
    t.integer  "posts_count",               default: 0,     null: false
    t.integer  "comments_count",            default: 0,     null: false
    t.integer  "balance",                   default: 0,     null: false
    t.string   "password_digest"
    t.string   "email"
    t.string   "screen_name"
    t.string   "name"
    t.string   "image"
  end

  add_index "users", ["slug", "network"], name: "index_users_on_slug_and_network", unique: true, using: :btree

  add_foreign_key "codes", "users"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_roles", "users"
end
