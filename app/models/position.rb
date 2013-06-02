class Position < ActiveRecord::Base
  attr_accessible :left, :note_id, :top, :z_index
  
  belongs_to :note
end
