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

ActiveRecord::Schema[7.1].define(version: 2024_09_16_195603) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_prices", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "name"
    t.string "billing_scheme"
    t.decimal "price_per_unit_percent"
    t.string "currency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_billing_prices_on_product_id"
  end

  create_table "billing_products", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_subscriptions", force: :cascade do |t|
    t.bigint "org_id", null: false
    t.bigint "price_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_billing_subscriptions_on_org_id"
    t.index ["price_id"], name: "index_billing_subscriptions_on_price_id"
  end

  create_table "fee_payments", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.bigint "org_id", null: false
    t.bigint "from_account_id", null: false
    t.index ["from_account_id"], name: "index_fee_payments_on_from_account_id"
    t.index ["org_id"], name: "index_fee_payments_on_org_id"
  end

  create_table "ocb_payouts", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "org_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["org_id"], name: "index_ocb_payouts_on_org_id"
  end

  create_table "onchain_billing_contracts", force: :cascade do |t|
    t.decimal "tab"
    t.bigint "org_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_onchain_billing_contracts_on_org_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plutus_accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "tenant_id"
    t.index ["name", "type"], name: "index_plutus_accounts_on_name_and_type"
    t.index ["tenant_id"], name: "index_plutus_accounts_on_tenant_id"
  end

  create_table "plutus_amounts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount", precision: 20, scale: 10
    t.index ["account_id", "entry_id"], name: "index_plutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "index_plutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "index_plutus_amounts_on_type"
  end

  create_table "plutus_entries", id: :serial, force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_plutus_entries_on_date"
  end

  create_table "reimbursements", force: :cascade do |t|
    t.bigint "org_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.index ["org_id"], name: "index_reimbursements_on_org_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.decimal "amount"
    t.bigint "org_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date"
    t.bigint "paid_to_id", null: false
    t.index ["org_id"], name: "index_rewards_on_org_id"
    t.index ["paid_to_id"], name: "index_rewards_on_paid_to_id"
  end

  add_foreign_key "billing_prices", "billing_products", column: "product_id"
  add_foreign_key "billing_subscriptions", "billing_prices", column: "price_id"
  add_foreign_key "billing_subscriptions", "orgs"
  add_foreign_key "fee_payments", "orgs"
  add_foreign_key "fee_payments", "plutus_accounts", column: "from_account_id"
  add_foreign_key "ocb_payouts", "orgs"
  add_foreign_key "onchain_billing_contracts", "orgs"
  add_foreign_key "reimbursements", "orgs"
  add_foreign_key "rewards", "orgs"
  add_foreign_key "rewards", "plutus_accounts", column: "paid_to_id"
end
