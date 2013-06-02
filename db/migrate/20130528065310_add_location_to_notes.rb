class AddLocationToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :location, :string
  end
end
