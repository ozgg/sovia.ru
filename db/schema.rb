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

ActiveRecord::Schema.define(version: 20170112094706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "agents", force: :cascade do |t|
    t.integer "browser_id"
    t.boolean "bot",        default: false, null: false
    t.boolean "mobile",     default: false, null: false
    t.boolean "active",     default: true,  null: false
    t.boolean "locked",     default: false, null: false
    t.boolean "deleted",    default: false, null: false
    t.string  "name",                       null: false
    t.index ["browser_id"], name: "index_agents_on_browser_id", using: :btree
    t.index ["name"], name: "index_agents_on_name", using: :btree
  end

  create_table "browsers", force: :cascade do |t|
    t.integer "agents_count", default: 0,     null: false
    t.boolean "bot",          default: false, null: false
    t.boolean "mobile",       default: false, null: false
    t.boolean "active",       default: true,  null: false
    t.boolean "locked",       default: false, null: false
    t.boolean "deleted",      default: false, null: false
    t.string  "name",                         null: false
  end

  create_table "codes", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "category",   limit: 2,             null: false
    t.integer  "quantity",   limit: 2, default: 1, null: false
    t.string   "body",                             null: false
    t.string   "payload"
    t.index ["agent_id"], name: "index_codes_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_codes_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "visible",          default: true,  null: false
    t.boolean  "deleted",          default: false, null: false
    t.boolean  "locked",           default: false, null: false
    t.integer  "commentable_id",                   null: false
    t.string   "commentable_type",                 null: false
    t.text     "body",                             null: false
    t.index ["agent_id"], name: "index_comments_on_agent_id", using: :btree
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "dream_grains", force: :cascade do |t|
    t.integer "dream_id", null: false
    t.integer "grain_id", null: false
    t.index ["dream_id"], name: "index_dream_grains_on_dream_id", using: :btree
    t.index ["grain_id"], name: "index_dream_grains_on_grain_id", using: :btree
  end

  create_table "dream_patterns", force: :cascade do |t|
    t.integer "dream_id",   null: false
    t.integer "pattern_id", null: false
    t.index ["dream_id"], name: "index_dream_patterns_on_dream_id", using: :btree
    t.index ["pattern_id"], name: "index_dream_patterns_on_pattern_id", using: :btree
  end

  create_table "dream_words", force: :cascade do |t|
    t.integer "dream_id", null: false
    t.integer "word_id",  null: false
    t.index ["dream_id"], name: "index_dream_words_on_dream_id", using: :btree
    t.index ["word_id"], name: "index_dream_words_on_word_id", using: :btree
  end

  create_table "dreams", force: :cascade do |t|
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.integer  "place_id"
    t.inet     "ip"
    t.integer  "privacy",              limit: 2, default: 0,     null: false
    t.boolean  "deleted",                        default: false, null: false
    t.boolean  "patterns_set",                   default: false, null: false
    t.integer  "lucidity",             limit: 2, default: 0,     null: false
    t.integer  "mood",                 limit: 2, default: 0,     null: false
    t.boolean  "needs_interpretation",           default: false, null: false
    t.boolean  "interpretation_given",           default: false, null: false
    t.integer  "comments_count",                 default: 0,     null: false
    t.boolean  "show_image",                     default: true,  null: false
    t.string   "uuid",                                           null: false
    t.string   "image"
    t.string   "title"
    t.string   "slug"
    t.text     "body",                                           null: false
    t.index "date_trunc('month'::text, created_at)", name: "dreams_created_month_idx", using: :btree
    t.index ["agent_id"], name: "index_dreams_on_agent_id", using: :btree
    t.index ["place_id"], name: "index_dreams_on_place_id", using: :btree
    t.index ["user_id"], name: "index_dreams_on_user_id", using: :btree
  end

  create_table "figures", force: :cascade do |t|
    t.integer "post_id"
    t.string  "slug",     null: false
    t.string  "image"
    t.string  "caption"
    t.string  "alt_text"
    t.index ["post_id"], name: "index_figures_on_post_id", using: :btree
  end

  create_table "fillers", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "user_id"
    t.integer  "gender",     limit: 2
    t.string   "title"
    t.text     "body"
    t.index ["user_id"], name: "index_fillers_on_user_id", using: :btree
  end

  create_table "grain_categories", force: :cascade do |t|
    t.integer "grains_count", default: 0,     null: false
    t.boolean "locked",       default: false, null: false
    t.boolean "deleted",      default: false, null: false
    t.string  "name",                         null: false
  end

  create_table "grains", force: :cascade do |t|
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "grain_category_id"
    t.integer  "user_id",                       null: false
    t.integer  "dreams_count",      default: 0, null: false
    t.string   "uuid",                          null: false
    t.string   "name",                          null: false
    t.string   "slug",                          null: false
    t.string   "image"
    t.text     "description"
    t.index ["grain_category_id"], name: "index_grains_on_grain_category_id", using: :btree
    t.index ["slug"], name: "index_grains_on_slug", using: :btree
    t.index ["user_id"], name: "index_grains_on_user_id", using: :btree
  end

  create_table "metric_values", force: :cascade do |t|
    t.integer  "metric_id",             null: false
    t.datetime "time",                  null: false
    t.integer  "quantity",  default: 1, null: false
    t.index "date_trunc('day'::text, \"time\")", name: "metric_values_day_idx", using: :btree
    t.index ["metric_id"], name: "index_metric_values_on_metric_id", using: :btree
  end

  create_table "metrics", force: :cascade do |t|
    t.string  "name",                           null: false
    t.string  "description"
    t.boolean "incremental",    default: false, null: false
    t.integer "value",          default: 0,     null: false
    t.integer "previous_value", default: 0,     null: false
  end

  create_table "pattern_words", force: :cascade do |t|
    t.integer "pattern_id"
    t.integer "word_id"
    t.index ["pattern_id"], name: "index_pattern_words_on_pattern_id", using: :btree
    t.index ["word_id"], name: "index_pattern_words_on_word_id", using: :btree
  end

  create_table "patterns", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "locked",         default: false, null: false
    t.boolean  "deleted",        default: false, null: false
    t.boolean  "described",      default: false, null: false
    t.integer  "dreams_count",   default: 0,     null: false
    t.integer  "comments_count", default: 0,     null: false
    t.integer  "words_count",    default: 0,     null: false
    t.string   "name",                           null: false
    t.string   "image"
    t.string   "essence"
    t.text     "description"
    t.index ["described"], name: "index_patterns_on_described", using: :btree
    t.index ["dreams_count"], name: "index_patterns_on_dreams_count", using: :btree
    t.index ["name"], name: "index_patterns_on_name", using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.integer "user_id"
    t.integer "dreams_count", default: 0, null: false
    t.string  "name",                     null: false
    t.text    "description"
    t.index ["user_id"], name: "index_places_on_user_id", using: :btree
  end

  create_table "post_tags", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id",  null: false
    t.index ["post_id"], name: "index_post_tags_on_post_id", using: :btree
    t.index ["tag_id"], name: "index_post_tags_on_tag_id", using: :btree
  end

  create_table "posts", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "deleted",        default: false, null: false
    t.boolean  "locked",         default: false, null: false
    t.boolean  "visible",        default: true,  null: false
    t.integer  "comments_count", default: 0,     null: false
    t.integer  "rating",         default: 0,     null: false
    t.integer  "upvote_count",   default: 0,     null: false
    t.integer  "downvote_count", default: 0,     null: false
    t.string   "image"
    t.string   "title"
    t.string   "slug"
    t.text     "lead"
    t.text     "body",                           null: false
    t.string   "tags_cache",     default: [],    null: false, array: true
    t.index "date_trunc('month'::text, created_at)", name: "posts_created_month_idx", using: :btree
    t.index ["agent_id"], name: "index_posts_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_posts_on_user_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "locked",         default: false, null: false
    t.boolean  "deleted",        default: false, null: false
    t.integer  "comments_count", default: 0,     null: false
    t.text     "body"
    t.index ["agent_id"], name: "index_questions_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_questions_on_user_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "posts_count", default: 0,     null: false
    t.boolean  "locked",      default: false, null: false
    t.boolean  "deleted",     default: false, null: false
    t.string   "name",                        null: false
    t.string   "slug",                        null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "last_used"
    t.integer  "user_id",                   null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.boolean  "active",     default: true, null: false
    t.string   "token",                     null: false
    t.index ["agent_id"], name: "index_tokens_on_agent_id", using: :btree
    t.index ["last_used"], name: "index_tokens_on_last_used", using: :btree
    t.index ["token"], name: "index_tokens_on_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_tokens_on_user_id", using: :btree
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id",           null: false
    t.integer "role",    limit: 2, null: false
    t.index ["user_id"], name: "index_user_roles_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "agent_id"
    t.inet     "ip"
    t.integer  "network",         limit: 2,                 null: false
    t.integer  "native_id"
    t.string   "slug",                                      null: false
    t.integer  "gender",          limit: 2
    t.boolean  "deleted",                   default: false, null: false
    t.boolean  "bot",                       default: false, null: false
    t.boolean  "allow_login",               default: true,  null: false
    t.boolean  "email_confirmed",           default: false, null: false
    t.boolean  "phone_confirmed",           default: false, null: false
    t.boolean  "allow_mail",                default: true,  null: false
    t.datetime "last_seen"
    t.date     "birthday"
    t.integer  "dreams_count",              default: 0,     null: false
    t.integer  "posts_count",               default: 0,     null: false
    t.integer  "comments_count",            default: 0,     null: false
    t.string   "password_digest"
    t.string   "email"
    t.string   "screen_name"
    t.string   "name"
    t.string   "partonymic"
    t.string   "surname"
    t.string   "phone"
    t.string   "image"
    t.string   "notice"
    t.integer  "questions_count",           default: 0,     null: false
    t.index ["agent_id"], name: "index_users_on_agent_id", using: :btree
    t.index ["slug", "network"], name: "index_users_on_slug_and_network", unique: true, using: :btree
  end

  create_table "violations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "agent_id"
    t.inet     "ip"
    t.string   "tag"
    t.string   "title"
    t.text     "body",       null: false
    t.index ["agent_id"], name: "index_violations_on_agent_id", using: :btree
    t.index ["user_id"], name: "index_violations_on_user_id", using: :btree
  end

  create_table "words", force: :cascade do |t|
    t.boolean "significant",  default: true,  null: false
    t.boolean "locked",       default: false, null: false
    t.boolean "processed",    default: false, null: false
    t.integer "dreams_count", default: 0,     null: false
    t.string  "body"
    t.index ["body"], name: "index_words_on_body", using: :btree
    t.index ["dreams_count"], name: "index_words_on_dreams_count", using: :btree
    t.index ["processed"], name: "index_words_on_processed", using: :btree
  end

  add_foreign_key "agents", "browsers"
  add_foreign_key "codes", "agents"
  add_foreign_key "codes", "users"
  add_foreign_key "comments", "agents"
  add_foreign_key "comments", "users"
  add_foreign_key "dream_grains", "dreams"
  add_foreign_key "dream_grains", "grains"
  add_foreign_key "dream_patterns", "dreams"
  add_foreign_key "dream_patterns", "patterns"
  add_foreign_key "dream_words", "dreams"
  add_foreign_key "dream_words", "words"
  add_foreign_key "dreams", "agents"
  add_foreign_key "dreams", "places"
  add_foreign_key "dreams", "users"
  add_foreign_key "figures", "posts"
  add_foreign_key "fillers", "users"
  add_foreign_key "grains", "grain_categories"
  add_foreign_key "grains", "users"
  add_foreign_key "metric_values", "metrics"
  add_foreign_key "pattern_words", "patterns"
  add_foreign_key "pattern_words", "words"
  add_foreign_key "places", "users"
  add_foreign_key "post_tags", "posts"
  add_foreign_key "post_tags", "tags"
  add_foreign_key "posts", "agents"
  add_foreign_key "posts", "users"
  add_foreign_key "questions", "agents"
  add_foreign_key "questions", "users"
  add_foreign_key "tokens", "agents"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_roles", "users"
  add_foreign_key "users", "agents"
  add_foreign_key "violations", "agents"
  add_foreign_key "violations", "users"
end
