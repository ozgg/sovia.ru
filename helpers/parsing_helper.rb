module ParsingHelper
  # Prepare post text for views
  #
  # @param [Post] post
  # @return [String]
  def prepare_post_text(post)
    simple_format post.body
  end

  # Prepare comment text for views
  #
  # @param [Comment] comment
  # @return [String]
  def prepare_comment_text(comment)
    raw comment.body.split("\n").map(&:squish).reject(&:blank?).map { |s| parse_common_string s }.join
  end

  # Parse fragments like [post 123](link text)
  #
  # @param [String] string
  # @return [String]
  def parse_post_links(string)
    pattern = /\[post (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      post  = Post.visible.find_by id: match[:id]
      if post.is_a? Post
        link_text = match[:text].blank? ? post.title : match[:text]
        link_tag  = link_to(link_text, post, title: post.title)
        "<cite>#{link_tag}</cite>"
      else
        '<span class="not-found">post ' + match[:id] + '</span>'
      end
    end
  end

  protected

  # Parse string as string from common text
  #
  # @param [String] string
  # @return [String]
  def parse_common_string(string)
    "<p>#{fragments_for_string(string)}</p>\n"
  end

  # Parse fragments available for common texts
  #
  # @param [String] string
  # @return [String]
  def fragments_for_string(string)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    parse_post_links quoted_string
  end
end
