# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_12_215641) do

  create_table "bot_chats", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "platform"
    t.string "external_token"
    t.integer "bot_id", null: false
    t.integer "message_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bot_id"], name: "index_bot_chats_on_bot_id"
    t.index ["external_token"], name: "index_bot_chats_on_external_token", unique: true
  end

  create_table "bots", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "status", default: 0
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "purchase_id", null: false
    t.index ["company_id"], name: "index_bots_on_company_id"
    t.index ["purchase_id"], name: "index_bots_on_purchase_id"
    t.index ["token"], name: "index_bots_on_token", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "token"
    t.string "name"
    t.string "cnpj"
    t.boolean "blocked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address"
    t.string "corporate_name"
    t.index ["cnpj"], name: "index_companies_on_cnpj", unique: true
    t.index ["token"], name: "index_companies_on_token", unique: true
  end

  create_table "plan_prices", force: :cascade do |t|
    t.integer "plan_id", null: false
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["plan_id"], name: "index_plan_prices_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "platforms"
    t.integer "limit_daily_chat"
    t.integer "limit_monthly_chat"
    t.integer "limit_daily_messages"
    t.integer "limit_monthly_messages"
    t.float "extra_message_price"
    t.float "extra_chat_price"
    t.integer "status", default: 0
    t.boolean "blocked_on_limit", default: false
    t.index ["name"], name: "index_plans_on_name", unique: true
  end

  create_table "purchase_cancellations", force: :cascade do |t|
    t.integer "purchase_id", null: false
    t.integer "status", default: 0
    t.integer "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reason"
    t.index ["purchase_id"], name: "index_purchase_cancellations_on_purchase_id"
    t.index ["user_id"], name: "index_purchase_cancellations_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "company_id", null: false
    t.integer "plan_id", null: false
    t.float "price"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.string "token"
    t.index ["company_id"], name: "index_purchases_on_company_id"
    t.index ["plan_id"], name: "index_purchases_on_plan_id"
    t.index ["token"], name: "index_purchases_on_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bot_chats", "bots"
  add_foreign_key "bots", "companies"
  add_foreign_key "bots", "purchases"
  add_foreign_key "plan_prices", "plans"
  add_foreign_key "purchase_cancellations", "purchases"
  add_foreign_key "purchase_cancellations", "users"
  add_foreign_key "purchases", "companies"
  add_foreign_key "purchases", "plans"
end
