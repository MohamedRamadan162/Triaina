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

ActiveRecord::Schema[8.0].define(version: 2025_03_04_055232) do
  create_schema "auth_service"
  create_schema "user_service"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "refresh_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "hashed_token", null: false
    t.datetime "issued_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "expires_at", precision: nil, default: -> { "(CURRENT_TIMESTAMP + 'P30D'::interval)" }, null: false
    t.datetime "revoked_at", precision: nil
    t.uuid "replaced_by_id"
    t.index ["replaced_by_id"], name: "index_refresh_tokens_on_replaced_by_id"
  end

  create_table "user_securities", primary_key: "user_id", id: :uuid, default: nil, force: :cascade do |t|
    t.string "hashed_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "refresh_tokens", "refresh_tokens", column: "replaced_by_id"
end
