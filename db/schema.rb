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

ActiveRecord::Schema.define(version: 20170220185203) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "uuid-ossp"

  create_table "categories", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "commits_count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.boolean  "default",       null: false
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "commits", force: :cascade do |t|
    t.text     "message"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id",         null: false
    t.string   "sha"
    t.string   "resource_uri"
    t.datetime "utc_commit_time"
    t.integer  "repository_id"
  end

  add_index "commits", ["repository_id"], name: "index_commits_on_repository_id", using: :btree
  add_index "commits", ["sha"], name: "index_commits_on_sha", unique: true, using: :btree
  add_index "commits", ["user_id"], name: "index_commits_on_user_id", using: :btree
  add_index "commits", ["utc_commit_time"], name: "index_commits_on_utc_commit_time", order: {"utc_commit_time"=>:desc}, using: :btree

  create_table "email_addresses", force: :cascade do |t|
    t.string   "email",      null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id", using: :btree

  create_table "filter_words", force: :cascade do |t|
    t.integer  "word_id"
    t.integer  "filterset_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "filter_words", ["filterset_id"], name: "index_filter_words_on_filterset_id", using: :btree
  add_index "filter_words", ["word_id"], name: "index_filter_words_on_word_id", using: :btree

  create_table "filtered_messages", force: :cascade do |t|
    t.integer  "filterset_id"
    t.integer  "commit_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "filter_word_id"
  end

  add_index "filtered_messages", ["commit_id"], name: "index_filtered_messages_on_commit_id", using: :btree
  add_index "filtered_messages", ["filter_word_id"], name: "index_filtered_messages_on_filter_word_id", using: :btree
  add_index "filtered_messages", ["filterset_id"], name: "index_filtered_messages_on_filterset_id", using: :btree

  create_table "filtersets", force: :cascade do |t|
    t.string   "name"
    t.integer  "commits_count"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "category_id"
  end

  add_index "filtersets", ["category_id"], name: "index_filtersets_on_category_id", using: :btree
  add_index "filtersets", ["name"], name: "index_filtersets_on_name", using: :btree

  create_table "repositories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "owner"
    t.string   "first_commit_sha"
    t.integer  "commits_count"
    t.text     "description"
    t.string   "avatar_uri"
    t.string   "resource_uri"
  end

  add_index "repositories", ["name"], name: "index_repositories_on_name", unique: true, using: :btree

  create_table "repository_languages", force: :cascade do |t|
    t.integer  "repository_id", null: false
    t.integer  "word_id",       null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "repository_languages", ["repository_id", "word_id"], name: "index_repository_languages_on_repository_id_and_word_id", unique: true, using: :btree
  add_index "repository_languages", ["repository_id"], name: "index_repository_languages_on_repository_id", using: :btree
  add_index "repository_languages", ["word_id"], name: "index_repository_languages_on_word_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "account_name",  null: false
    t.string   "avatar_uri"
    t.integer  "commits_count"
    t.string   "resource_uri"
  end

  add_index "users", ["account_name"], name: "index_users_on_account_name", using: :btree

  create_table "words", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "words", ["value"], name: "index_words_on_value", unique: true, using: :btree

end
