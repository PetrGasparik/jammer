class AddInvestmentRatioToUsers < ActiveRecord::Migration
  def change
    add_column :users, :investment_ratio, :float
  end
end
