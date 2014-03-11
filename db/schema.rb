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

ActiveRecord::Schema.define(version: 20140311184917) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "codes", force: true do |t|
    t.integer  "user_id"
    t.string   "type",                       null: false
    t.string   "body",                       null: false
    t.string   "payload"
    t.boolean  "activated",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "codes", ["body"], name: "index_codes_on_body", unique: true, using: :btree
  add_index "codes", ["user_id"], name: "index_codes_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "entry_id"
    t.integer  "parent_id"
    t.integer  "user_id"
    t.boolean  "is_visible", default: true, null: false
    t.text     "body",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["entry_id"], name: "index_comments_on_entry_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

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

  create_table "user_tags", force: true do |t|
    t.integer "user_id",                   null: false
    t.integer "tag_id",                    null: false
    t.integer "entries_count", default: 0, null: false
  end

  add_index "user_tags", ["tag_id"], name: "index_user_tags_on_tag_id", using: :btree
  add_index "user_tags", ["user_id", "tag_id"], name: "index_user_tags_on_user_id_and_tag_id", unique: true, using: :btree
  add_index "user_tags", ["user_id"], name: "index_user_tags_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                           null: false
    t.string   "email"
    t.string   "password_digest",                 null: false
    t.string   "avatar"
    t.boolean  "mail_confirmed",  default: false, null: false
    t.boolean  "allow_mail",      default: false, null: false
    t.integer  "entries_count",   default: 0,     null: false
    t.integer  "comments_count",  default: 0,     null: false
    t.integer  "roles_mask",      default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
