class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name 
      t.text :words
      t.string :word_type
      t.timestamps
    end
  end
end
