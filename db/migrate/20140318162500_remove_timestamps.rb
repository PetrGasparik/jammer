class RemoveTimestamps < ActiveRecord::Migration
  def change
    remove_column :users, :created_at
    remove_column :users, :updated_at
    remove_column :loans, :created_at
    remove_column :loans, :updated_at
    remove_column :investments, :created_at
    remove_column :investments, :updated_at
  end
end
