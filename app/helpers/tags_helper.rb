module TagsHelper
  
  def pluralize_number_times(num)
    if num == 0
      "never"
    elsif num == 1
      "once"
    elsif num == 2
      "twice"
    else
      "#{num} times"
    end
  end
end
