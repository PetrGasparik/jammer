class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :key
      t.text :value

      t.timestamps
    end
    add_index :parameters, :key, :unique => true
  end
end
