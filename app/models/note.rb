class Note < ActiveRecord::Base
  attr_accessible :content, :project_id, :title, :location
  
  belongs_to :project
  has_many :note_taggings
  has_many :tags, through: :note_taggings
  has_one :position, dependent: :destroy
  
  def self.get_count(proj)
    find_all_by_project_id(proj.id).count
  end  
  
  
  def add_tag_numbers(tag_numbers)
    ts = tags 
    ts.each do |t|
      if tag_numbers[:tag_id => t.id].nil?
        tag_numbers[:tag_id => t.id] = 1
      else
        tag_numbers[:tag_id => t.id] += 1
      end
    end
  end
  
end
