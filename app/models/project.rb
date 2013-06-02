class Project < ActiveRecord::Base
  attr_accessible :name, :summary, :description
  
  has_many :notes, :dependent => :destroy
  has_many :note_tags, :through => :notes, :source => :tags
  has_many :tags
  
  
  def add_tag_numbers(tag_numbers)
    ts = tags 
    ts.each do |t|
      if tag_numbers[:tag_id => t.id].nil?
        tag_numbers[:tag_id => t.id] = 1
      else
        tag_numbers[:tag_id => t.id] += 1
      end
    end
    
    notes.each do |n|
      n.add_tag_numbers(tag_numbers)
    end
  end
end
