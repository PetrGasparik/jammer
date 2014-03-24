class AddCreditRatingToUsers < ActiveRecord::Migration
  def change
    add_column :users, :credit_rating, :integer
  end
end
