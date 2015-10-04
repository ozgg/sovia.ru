module DreamsHelper
  def parsed_dream_body(dream, current_user)
    buffer, @show_names = '', dream.owned_by?(current_user)
    dream.body.split("\n").each { |string| buffer += process_string string.squish, current_user }
    buffer
  end


  protected

  def process_string(string, current_user)
    if string.blank?
      ''
    else
      "<p>#{quote_and_parse string, current_user}</p>"
    end
  end

  def quote_and_parse(string, current_user)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    string_with_dreams = parse_dream_links(quoted_string, current_user)
    parse_names string_with_dreams
  end
end
