class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.float :advertised_amount
      t.float :remaining_fund_amount
      t.float :advertised_rate
      t.float :btc_per_payment
      t.boolean :exchange_linked
      t.integer :term
      t.string :state
      t.string :name

      t.timestamps
    end

    add_index :loans, :user_id
  end
end
