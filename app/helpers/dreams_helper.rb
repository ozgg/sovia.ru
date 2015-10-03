module DreamsHelper
  def parsed_dream_body(dream, current_user)
    buffer = ''
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
    parse_dream_links(quoted_string, current_user)
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
end
