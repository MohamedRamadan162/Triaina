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

ActiveRecord::Schema[8.0].define(version: 2025_03_05_205453) do
  create_schema "user_service"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "refresh_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "hashed_token", null: false
    t.datetime "issued_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "expires_at", precision: nil, default: -> { "(CURRENT_TIMESTAMP + 'P30D'::interval)" }, null: false
    t.datetime "revoked_at", precision: nil
    t.uuid "replaced_by"
    t.index ["hashed_token"], name: "index_refresh_tokens_on_hashed_token", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "user_securities", primary_key: "user_id", id: :uuid, default: nil, force: :cascade do |t|
    t.string "password_digest", null: false
    t.datetime "password_updated_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "username", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.boolean "email_verified", default: false, null: false
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "refresh_tokens", "refresh_tokens", column: "replaced_by", on_delete: :nullify
  add_foreign_key "refresh_tokens", "users", on_delete: :cascade
  add_foreign_key "user_securities", "users", on_delete: :cascade
end
