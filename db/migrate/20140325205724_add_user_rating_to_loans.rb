class AddUserRatingToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :user_rating, :integer
  end
end
