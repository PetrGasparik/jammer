class AddAliasIndexToUsers < ActiveRecord::Migration
  def change
    add_index :users, :alias
  end
end
