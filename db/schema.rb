# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_07_162738) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "chat_members", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.integer "role", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["chat_id"], name: "index_chat_members_on_chat_id"
    t.index ["user_id", "chat_id"], name: "index_chat_members_on_user_id_and_chat_id", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.integer "chat_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.bigint "replied_message_id"
    t.text "text"
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_messages_on_author_id"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
    t.index ["replied_message_id"], name: "index_messages_on_replied_message_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.citext "username", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "chat_members", "chats"
  add_foreign_key "chat_members", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "messages", "messages", column: "replied_message_id"
  add_foreign_key "messages", "users", column: "author_id"
  add_foreign_key "sessions", "users"
end
