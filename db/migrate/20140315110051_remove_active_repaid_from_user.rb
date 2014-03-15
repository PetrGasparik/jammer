class RemoveActiveRepaidFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :active_btc
    remove_column :users, :active_count
    remove_column :users, :repaid_btc
    remove_column :users, :repaid_count
  end
end
