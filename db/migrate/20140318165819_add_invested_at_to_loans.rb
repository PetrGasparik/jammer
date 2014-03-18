class AddInvestedAtToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :invested_at, :datetime
  end
end
