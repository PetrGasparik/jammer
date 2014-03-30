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

ActiveRecord::Schema.define(version: 20140330203053) do

  create_table "impressions", force: true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "investments", force: true do |t|
    t.integer  "user_id"
    t.integer  "loan_id"
    t.integer  "amount",        limit: 8
    t.datetime "invested_at"
    t.string   "state"
    t.string   "loan_name"
    t.string   "user_name"
    t.string   "borrower_name"
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
    t.string   "frequency"
    t.datetime "invested_at"
    t.string   "user_name"
    t.integer  "user_rating"
  end

  add_index "loans", ["state"], name: "index_loans_on_state", using: :btree
  add_index "loans", ["user_id", "state"], name: "index_loans_on_user_id_and_state", using: :btree
  add_index "loans", ["user_id"], name: "index_loans_on_user_id", using: :btree

  create_table "parameters", force: true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parameters", ["key"], name: "index_parameters_on_key", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "alias"
    t.integer  "payments_count"
    t.integer  "payments_btc",                  limit: 8
    t.integer  "overdue_count"
    t.integer  "overdue_btc",                   limit: 8
    t.integer  "loan_count"
    t.integer  "repaid_btc",                    limit: 8
    t.integer  "active_btc",                    limit: 8
    t.integer  "funding_btc",                   limit: 8
    t.integer  "total_debt",                    limit: 8
    t.integer  "future_debt",                   limit: 8
    t.integer  "investments_btc",               limit: 8
    t.integer  "active_investments_btc",        limit: 8
    t.integer  "overdue_investments_btc",       limit: 8
    t.integer  "funding_investments_btc",       limit: 8
    t.integer  "repaid_investments_btc",        limit: 8
    t.integer  "active_count"
    t.integer  "repaid_count"
    t.integer  "funding_count"
    t.integer  "overdue_loan_count"
    t.integer  "investments_count"
    t.integer  "active_investments_count"
    t.integer  "overdue_investments_count"
    t.integer  "funding_investments_count"
    t.integer  "repaid_investments_count"
    t.boolean  "total_debt_has_exchange_link"
    t.boolean  "future_debt_has_exchange_link"
    t.float    "investment_ratio"
    t.datetime "last_active_at"
    t.integer  "credit_rating"
    t.string   "avatar"
    t.string   "btcjam_token"
  end

  add_index "users", ["alias"], name: "index_users_on_alias", using: :btree

end
