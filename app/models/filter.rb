class Filter < ActiveRecord::Base
  attr_accessible :name, :str, :search_type
    
  validates :name, :presence => true    
  validates_uniqueness_of :name 


  def self.filter_notes(all_notes,search_str,search_type)
    if search_str==""
      notes = all_notes.order("created_at desc")
    elsif search_type=="Tags" 
      where_str = ""
      tags = search_str.split(/[,;]/)
      tags.each_with_index do |t,i|
        where_str += " OR " if i>0
        where_str += "t.name like '%#{t.strip}%'"
      end
      notes_tmp = all_notes.select("notes.*, count(*) c").joins("inner join note_taggings n on notes.id = n.note_id inner join tags t on n.tag_id = t.id").group("note_id").where(where_str)
      notes = []
      notes_tmp.each do |n|
        notes << n if n.c == tags.count
      end
    else
      words = search_str.split(/[,;]/)
      where_str = "("
      words.each_with_index do |t,i|
        where_str += " AND " if i>0 
        where_str += "notes.content like '%#{t.strip}%'"
      end
      where_str += ") OR ("
      words.each_with_index do |t,i|
        where_str += " AND " if i>0 
        where_str += "notes.title like '%#{t.strip}%'"
      end
      where_str += ")"
      notes = all_notes.order("created_at desc").where(where_str).uniq
    end
    notes
  end

end
