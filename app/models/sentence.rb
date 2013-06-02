class Sentence
  
  
  # returns an array of sentences terminated by ".", "?", or "!"
  def self.get_sentences(str)
    str = Sentence.strip(str)   
    str = Sentence.remove_newlines(str)
    str = Sentence.terminate_with_period(str)
    strs = str.scan(/[^\.!\?]+[\.!\?]+/)
    sentences = []
    strs.each do |s|
      sentences << Sentence.new(s)
      puts s
    end
    sentences
  end

  def self.strip(str)
    str.gsub(/(<([^>]+)>)/,"").gsub(/&nbsp;/i," ")  
  end

  def self.remove_newlines(str)
    str.gsub(/[\n\r]/," ")
  end
  
  def self.terminate_with_period(str)
    if !str[str.length-1].match(/[\.!\?\n]/)
      str += "."
    end
    str
  end
  
  def initialize(str)
    @sentence = str
  end
  
  def is_word_type?(word_list)
    regex = string_words_for_regex(word_list)  
    if !regex.nil?
      regex += ")" 
      return @sentence.match(regex)
    end
    false
  end

  def strip(word_list)
    regex = string_words_for_regex(word_list)  
    if !regex.nil?
      regex += ")" 
      @sentence = @sentence.gsub(regex,"")
    end
  end

  def string_words_for_regex(word_list)
    regex = nil
    word_list.each do |w|
      if regex.nil?
        regex = "(#{w.word}" 
      else
        regex += "|#{w.word}"
      end
    end
    regex
  end
  
 
  def is_question?
    @sentence.match(/\?/)      
  end
  
  def to_str
    @sentence
  end
end