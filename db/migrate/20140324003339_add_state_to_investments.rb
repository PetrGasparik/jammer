class AddStateToInvestments < ActiveRecord::Migration
  def change
    add_column :investments, :state, :string
  end
end
