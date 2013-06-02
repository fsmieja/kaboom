class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :top
      t.integer :left
      t.integer :z_index
      t.integer :note_id

      t.timestamps
    end
  end
end
