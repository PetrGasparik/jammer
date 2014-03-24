class AddUserNameToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :user_name, :string
  end
end
