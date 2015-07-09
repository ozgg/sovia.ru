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

ActiveRecord::Schema.define(version: 20150709102041) do

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

  create_table "languages", force: :cascade do |t|
    t.string "code", null: false
    t.string "slug", null: false
  end

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

  add_foreign_key "agents", "browsers"
  add_foreign_key "tags", "languages"
end
