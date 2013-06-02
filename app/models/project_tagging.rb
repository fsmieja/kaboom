class ProjectTagging < ActiveRecord::Base
  attr_accessible :project_id, :tag_id
  
  belongs_to :project
  belongs_to :tag
end
