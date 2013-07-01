class ChangeFilterFields < ActiveRecord::Migration
  def change
    add_column :filters, :str, :string
    add_column :filters, :search_type, :string
    remove_column :filters, :words
    remove_column :filters, :word_type
  end
end
