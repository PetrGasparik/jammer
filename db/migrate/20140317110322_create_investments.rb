class CreateInvestments < ActiveRecord::Migration
  def change
    create_table :investments do |t|
      t.integer :user_id
      t.integer :loan_id
      t.integer :amount, :limit => 8
      t.datetime :invested_at

      t.timestamps
    end

    add_index :investments, :user_id
    add_index :investments, :loan_id
    add_index :investments, [:user_id, :loan_id, :invested_at], :unique => true
  end
end
