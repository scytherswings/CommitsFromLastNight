# frozen_string_literal: true

class InitSchema < ActiveRecord::Migration[5.2]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    create_table "categories", id: :serial do |t|
      t.string "name", null: false
      t.integer "commits_count"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "default", null: false
      t.index ["name"], name: "index_categories_on_name", unique: true
    end
    create_table "commits", id: :serial do |t|
      t.text "message"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "user_id", null: false
      t.string "sha"
      t.string "resource_uri"
      t.datetime "utc_commit_time"
      t.integer "repository_id"
      t.index ["repository_id"], name: "index_commits_on_repository_id"
      t.index ["sha"], name: "index_commits_on_sha", unique: true
      t.index ["user_id"], name: "index_commits_on_user_id"
      t.index ["utc_commit_time"], name: "index_commits_on_utc_commit_time", order: :desc
    end
    create_table "email_addresses", id: :serial do |t|
      t.string "email", null: false
      t.integer "user_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_email_addresses_on_user_id"
    end
    create_table "filter_words", id: :serial do |t|
      t.integer "word_id"
      t.integer "filterset_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["filterset_id"], name: "index_filter_words_on_filterset_id"
      t.index ["word_id"], name: "index_filter_words_on_word_id"
    end
    create_table "filtered_messages", id: :serial do |t|
      t.integer "filterset_id"
      t.integer "commit_id"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "filter_word_id"
      t.index ["commit_id"], name: "index_filtered_messages_on_commit_id"
      t.index ["filter_word_id"], name: "index_filtered_messages_on_filter_word_id"
      t.index ["filterset_id"], name: "index_filtered_messages_on_filterset_id"
    end
    create_table "filtersets", id: :serial do |t|
      t.string "name"
      t.integer "commits_count"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "category_id"
      t.index ["category_id"], name: "index_filtersets_on_category_id"
      t.index ["name"], name: "index_filtersets_on_name"
    end
    create_table "repositories", id: :serial do |t|
      t.string "name"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "owner"
      t.string "first_commit_sha"
      t.integer "commits_count"
      t.text "description"
      t.string "avatar_uri"
      t.string "resource_uri"
      t.index ["name"], name: "index_repositories_on_name", unique: true
    end
    create_table "repository_languages", id: :serial do |t|
      t.integer "repository_id", null: false
      t.integer "word_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index %w[repository_id word_id], name: "index_repository_languages_on_repository_id_and_word_id", unique: true
      t.index ["repository_id"], name: "index_repository_languages_on_repository_id"
      t.index ["word_id"], name: "index_repository_languages_on_word_id"
    end
    create_table "users", id: :serial do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "account_name", null: false
      t.string "avatar_uri"
      t.integer "commits_count"
      t.string "resource_uri"
      t.index ["account_name"], name: "index_users_on_account_name"
    end
    create_table "words", id: :serial do |t|
      t.string "value", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["value"], name: "index_words_on_value", unique: true
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
