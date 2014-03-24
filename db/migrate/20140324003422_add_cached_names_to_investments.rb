class AddCachedNamesToInvestments < ActiveRecord::Migration
  def change
    add_column :investments, :loan_name, :string
    add_column :investments, :user_name, :string
    add_column :investments, :borrower_name, :string
  end
end
