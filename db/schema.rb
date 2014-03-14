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

ActiveRecord::Schema.define(version: 20140314123325) do

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.float    "advertised_amount"
    t.float    "remaining_fund_amount"
    t.float    "advertised_rate"
    t.float    "btc_per_payment"
    t.boolean  "exchange_linked"
    t.integer  "term"
    t.string   "state"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payments_count"
    t.float    "payments_btc"
    t.integer  "active_count"
    t.float    "active_btc"
    t.integer  "repaid_count"
    t.float    "repaid_btc"
    t.integer  "funding_count"
    t.float    "funding_btc"
    t.integer  "overdue_count"
    t.float    "overdue_btc"
  end

  add_index "users", ["alias"], name: "index_users_on_alias", using: :btree

end
