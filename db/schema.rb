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

ActiveRecord::Schema.define(version: 20140317125823) do

  create_table "investments", force: true do |t|
    t.integer  "user_id"
    t.integer  "loan_id"
    t.integer  "amount",      limit: 8
    t.datetime "invested_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investments", ["loan_id"], name: "index_investments_on_loan_id", using: :btree
  add_index "investments", ["user_id", "loan_id"], name: "index_investments_on_user_id_and_loan_id", using: :btree
  add_index "investments", ["user_id"], name: "index_investments_on_user_id", using: :btree

  create_table "loans", force: true do |t|
    t.integer  "user_id"
    t.integer  "advertised_amount",     limit: 8
    t.integer  "remaining_fund_amount", limit: 8
    t.float    "advertised_rate"
    t.integer  "btc_per_payment",       limit: 8
    t.boolean  "exchange_linked"
    t.integer  "term"
    t.string   "state"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "frequency"
  end

  add_index "loans", ["state"], name: "index_loans_on_state", using: :btree
  add_index "loans", ["user_id", "state"], name: "index_loans_on_user_id_and_state", using: :btree
  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payments_count"
    t.integer  "payments_btc",   limit: 8
    t.integer  "overdue_count"
    t.integer  "overdue_btc",    limit: 8
  end

  add_index "users", ["alias"], name: "index_users_on_alias", using: :btree

end
