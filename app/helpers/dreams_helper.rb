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

  def parse_dream_links(string, current_user)
    pattern = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,30})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      dream = Dream.get_if_visible(match[:id], current_user)
      if dream.is_a? Dream
        link_text = match[:text].blank? ? dream.title_for_view : match[:text]
        "«#{link_to link_text, dream, title: dream.title_for_view}»"
      else
        '<span class="not-found">dream ' + match[:id] + '</span>'
      end
    end
  end

  def parse_names(string)
    pattern = /\{(?<name>[^}]{1,30})\}(?:\((?<text>[^)]{1,30})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      if match[:text]
        name = match[:text]
      else
        name = match[:name].split(/[\s-]+/).map { |word| word.first }.join('')
      end
      attribute = @show_names ? " title=\"#{match[:name]}\"" : ''
      "<span class=\"name\"#{attribute}>#{name}</span>"
    end
  end
end
