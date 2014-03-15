class DropFundingColumnsFromUsers < ActiveRecord::Migration
  def change
    remove_column(:users, :funding_count)
    remove_column(:users, :funding_btc)
  end
end
