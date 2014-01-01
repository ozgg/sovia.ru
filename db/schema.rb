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

ActiveRecord::Schema.define(version: 20140101222748) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: true do |t|
    t.integer  "user_id",                    null: false
    t.string   "title",                      null: false
    t.text     "body",                       null: false
    t.integer  "comments_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "dreams", force: true do |t|
    t.integer  "user_id"
    t.integer  "privacy",        default: 0, null: false
    t.integer  "comments_count", default: 0, null: false
    t.string   "title"
    t.text     "body",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dreams", ["privacy"], name: "index_dreams_on_privacy", using: :btree
  add_index "dreams", ["user_id"], name: "index_dreams_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                           null: false
    t.string   "email"
    t.string   "password_digest",                 null: false
    t.string   "avatar"
    t.boolean  "mail_confirmed",  default: false, null: false
    t.boolean  "allow_mail",      default: false, null: false
    t.integer  "entries_count",   default: 0,     null: false
    t.integer  "comments_count",  default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
