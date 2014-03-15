class AddFrequencyToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :frequency, :string
  end
end
