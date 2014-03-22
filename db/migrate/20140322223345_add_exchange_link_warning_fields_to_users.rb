class AddExchangeLinkWarningFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :total_debt_has_exchange_link, :boolean
    add_column :users, :future_debt_has_exchange_link, :boolean
  end
end
