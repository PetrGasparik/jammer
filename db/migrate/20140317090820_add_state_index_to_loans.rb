class AddStateIndexToLoans < ActiveRecord::Migration
  def change
    add_index :loans, :state
    add_index :loans, [:user_id, :state]
  end
end
