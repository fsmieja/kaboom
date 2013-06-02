class CreateProjectTaggings < ActiveRecord::Migration
  def change
    create_table :project_taggings do |t|
      t.integer :project_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
