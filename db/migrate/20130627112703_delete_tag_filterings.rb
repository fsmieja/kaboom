class DeleteTagFilterings < ActiveRecord::Migration
  def change
    drop_table :tag_filterings
  end
end
