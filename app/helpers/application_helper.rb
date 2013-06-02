module ApplicationHelper
  def logo
    image_tag("rails.png", :alt => "Logo", :class => "logo")#,  :size => "246x82")
  end

  
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction, :per_page => params[:per_page]}, {:class => css_class}
  end
  
  def get_actions(msg)
    sentences = Sentence.get_sentences(msg)
    actions = []
    action_words = Word.find_all_by_word_type('action')
    strip_words = Word.find_all_by_word_type('strip')
    sentences.each do |s|
      s.strip(strip_words)
      if s.is_word_type?(action_words)
        actions << "#{s.to_str}"
      end
    end
    actions
  end  
  
  def get_events(msg)
    sentences = Sentence.get_sentences(msg)
    events = []
    event_words = Word.find_all_by_word_type('event')
    sentences.each do |s|
      if s.is_word_type?(event_words)
        events << "#{s.to_str}"
      end
    end
    events
  end    
end
