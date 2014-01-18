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

ActiveRecord::Schema.define(version: 20140118140404) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entry_tags", force: true do |t|
    t.string   "letter",                     null: false
    t.string   "name",                       null: false
    t.string   "canonical_name",             null: false
    t.integer  "dreams_count",   default: 0, null: false
    t.integer  "users_count",    default: 0, null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "entry_tags", ["canonical_name"], name: "index_entry_tags_on_canonical_name", unique: true, using: :btree
  add_index "entry_tags", ["letter"], name: "index_entry_tags_on_letter", using: :btree
  add_index "entry_tags", ["name"], name: "index_entry_tags_on_name", using: :btree

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "entry_type",                 null: false
    t.integer  "privacy",        default: 0, null: false
    t.string   "title"
    t.string   "url_title"
    t.text     "body",                       null: false
    t.integer  "comments_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["entry_type", "privacy"], name: "index_posts_on_entry_type_and_privacy", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "posts_entry_tags", force: true do |t|
    t.integer "post_id",      null: false
    t.integer "entry_tag_id", null: false
  end

  add_index "posts_entry_tags", ["entry_tag_id"], name: "index_posts_entry_tags_on_entry_tag_id", using: :btree
  add_index "posts_entry_tags", ["post_id", "entry_tag_id"], name: "index_posts_entry_tags_on_post_id_and_entry_tag_id", unique: true, using: :btree
  add_index "posts_entry_tags", ["post_id"], name: "index_posts_entry_tags_on_post_id", using: :btree

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
