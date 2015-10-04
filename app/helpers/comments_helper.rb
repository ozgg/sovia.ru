module CommentsHelper
  def url_to_comment(comment)
    'no url yet'
  end

  def parsed_comment_body(comment, current_user)
    buffer = ''
    comment.body.split("\n").each { |string| buffer += process_string string.squish, current_user }
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
    string_with_posts = parse_post_links(string_with_dreams)
    parse_pattern_links(string_with_posts)
  end
end
