class AddBtcjamTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :btcjam_token, :string
  end
end
