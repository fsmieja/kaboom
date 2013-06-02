class Tag < ActiveRecord::Base
  attr_accessible :name
  
  has_many :note_taggings
  has_many :notes, through: :note_taggings
  has_many :project_taggings
  has_many :projects, through: :project_taggings
  has_many :note_projects, through: :notes, source: :projects 
  
  
  def self.create_tags(name,many=false)
    if many
      tags = name.gsub(/[ \t\r]/,'').split(/[\n;,]/)
      tags.each do |t|
        this_tag = new({:name => t})
        return false if !this_tag.save!
      end
    else
      this_tag = new({:name => name})
      return false if !this_tag.save!
    end
    true
  end
  
  def self.find_or_create_tag(tag_name)
    if tag_name.size<2
      return nil
    end
    return Tag.find_or_create_by_name(tag_name)
  end
end
