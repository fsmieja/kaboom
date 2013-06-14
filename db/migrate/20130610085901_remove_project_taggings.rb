class RemoveProjectTaggings < ActiveRecord::Migration
  def change
    drop_table :project_taggings
  end
end
