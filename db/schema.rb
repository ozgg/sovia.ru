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

ActiveRecord::Schema.define(version: 20160627000010) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "browser_id"
    t.boolean  "bot",        default: false, null: false
    t.boolean  "mobile",     default: false, null: false
    t.boolean  "active",     default: true,  null: false
    t.boolean  "locked",     default: false, null: false
    t.boolean  "deleted",    default: false, null: false
    t.string   "name",                       null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id", using: :btree
    t.index ["name"], name: "index_agents_on_name", using: :btree
  end

  create_table "browsers", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "agents_count", default: 0,     null: false
    t.boolean  "bot",          default: false, null: false
    t.boolean  "mobile",       default: false, null: false
    t.boolean  "active",       default: true,  null: false
    t.boolean  "locked",       default: false, null: false
    t.boolean  "deleted",      default: false, null: false
    t.string   "name",                         null: false
    t.index ["name"], name: "index_browsers_on_name", using: :btree
  end

  add_foreign_key "agents", "browsers"
end
