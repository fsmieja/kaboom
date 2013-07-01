class Note < ActiveRecord::Base
  attr_accessible :content, :project_id, :title, :location
  
  belongs_to :project
  
  has_many :note_taggings
  has_many :tags, through: :note_taggings
  has_one :position, dependent: :destroy
  
  def self.add_tag_numbers(notes, tag_numbers)
    tags = []
     notes.each do |n|    
       n.add_tag_numbers(tag_numbers)
       tags = tags + n.tags
    end
    tags = tags.uniq
  end
  
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
  
  def get_node_notes(exc=[])
    node_notes = []
    tags.each do |t| 
      t.notes.each do |n|
        if n!=self && !node_notes.include?(n) && !exc.include?(n)
          node_notes << n
        end
      end
    end
    node_notes
  end    
end
