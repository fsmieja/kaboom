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
  
  def self.get_search_results(all_notes, search_type, search_str, focus_digress)
    if focus_digress.nil?
      return all_notes
    end
    conjunction = focus_digress.include?("Focus") ? "AND" : "OR"
    
    where_str = ""
    words = search_str.split(/[,;]/)
    words.each_with_index do |t,i|
      where_str = where_str + " #{conjunction} " if i>0
      wrd = t.strip
      if @search_type=="Tags"
        where_str = where_str + "t.name like '%#{wrd}%'"
      else
        where_str = where_str + "(notes.title like '%#{wrd}%' OR notes.content like '%#{wrd}%') "
      end
    end
    if @search_type=="Tags"
      notes = all_notes.joins("inner join note_taggings n on notes.id = n.note_id inner join tags t on n.tag_id = t.id LEFT OUTER JOIN positions on positions.note_id = notes.id").order("z_index asc").where(where_str).uniq
    else
      notes = all_notes.joins("LEFT OUTER JOIN positions on positions.note_id = notes.id").order("z_index asc").where(where_str).uniq
    end
    notes
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
