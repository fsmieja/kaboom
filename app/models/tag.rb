class Tag < ActiveRecord::Base
  attr_accessible :name

  belongs_to :project
  
  has_many :note_taggings
  has_many :tag_filterings
  has_many :notes, through: :note_taggings
  has_many :filters, through: :tag_filterings
  
  
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

  def get_node_tags(exc=[])
    node_tags = []
    notes.each do |n| 
      n.tags.each do |t|
        if t!=self && !node_tags.include?(t) && !exc.include?(t)
          node_tags << t
        end
      end
    end
    node_tags
  end  
  private
  

end
