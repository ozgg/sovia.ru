module ParsingHelper
  # @param [String] text
  # @param [Integer] passages
  def preview(text, passages = 2)
    text.split("</p>\n<p>")[0...passages].join('</p><p>')
  end

  # Prepare post text for views
  #
  # @param [Post] post
  # @return [String]
  def prepare_post_text(post)
    raw post.body.split("\n").map(&:squish).reject(&:blank?).map { |s| parse_post_string(post, s) }.join
  end

  # @param [Dream] dream
  # @param [User] user
  def prepare_dream_text(dream, user)
    owner = dream.user
    raw dream.body.split("\n").map(&:squish).reject(&:blank?).map { |s| parse_dream_string s, owner, user }.join
  end

  # Prepare comment text for views
  #
  # @param [Comment] comment
  # @param [User] user
  # @return [String]
  def prepare_comment_text(comment, user)
    raw comment.body.split("\n").map(&:squish).reject(&:blank?).map { |s| parse_comment_string s, user }.join
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

  # Parse fragments like [dream 123](link text)
  #
  # @param [String] string
  # @param [User] user
  # @return [String]
  def parse_dream_links(string, user)
    pattern = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      dream = Dream.not_deleted.find_by id: match[:id]
      if dream.is_a?(Dream) && dream.visible_to?(user)
        link_text = match[:text].blank? ? (dream.title || t(:untitled)) : match[:text]
        link_tag  = link_to(link_text, dream, title: (dream.title || t(:untitled)))
        "<cite>#{link_tag}</cite>"
      else
        '<span class="not-found">dream ' + match[:id] + '</span>'
      end
    end
  end

  def parse_figure_links(post, string)
    pattern = Figure::LINK_PATTERN
    string.gsub pattern do |chunk|
      match  = pattern.match chunk
      figure = post.figures.find_by(slug: match[:id])
      if figure.is_a? Figure
        image   = image_tag(figure.image.big.url, alt: figure.text_for_alt)
        caption = figure.caption.blank? ? '' : "<figcaption>#{figure.caption}</figcaption>"
        "<figure>#{image}#{caption}</figure>\n"
      else
        '<figure><span class="not-found">figure ' + match[:id] + "</span></figure>\n"
      end
    end
  end

  # Parse fragments like [[Pattern]](link text)
  #
  # @param [String] string
  # @return [String]
  def parse_pattern_links(string)
    regex = /\[\[(?<body>[^\]]{1,50})\]\](?:\((?<text>[^)]{1,64})\))?/
    string.gsub regex do |chunk|
      match   = regex.match chunk
      pattern = Pattern.match_by_name match[:body]
      if pattern.is_a? Pattern
        link_text = match[:text].blank? ? match[:body] : match[:text]
        link_to link_text, dreambook_word_path(word: pattern.name)
      else
        '<span class="not-found">' + match[:body] + '</span>'
      end
    end
  end

  # Parse fragments like {Real Name}(text)
  #
  # @param [String] string
  # @param [Boolean] show_names
  # @return [String]
  def parse_names(string, show_names)
    pattern = /\{(?<name>[^}]{1,30})\}(?:\((?<text>[^)]{1,30})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      if match[:text]
        name = match[:text]
      else
        name = match[:name].split(/[\s-]+/).map { |word| word.first }.join('')
      end
      attribute = show_names ? " title=\"#{match[:name]}\"" : ''
      "<span class=\"name\"#{attribute}>#{name}</span>"
    end
  end

  protected

  def parse_post_string(post, string)
    if string =~ Figure::LINK_PATTERN
      parse_figure_links post, string
    else
      output = parse_pattern_links string
      output[0] == '<' ? output : "<p>#{output}</p>"
    end
  end

  # @param [String] string
  # @param [User] owner
  # @param [User] user
  def parse_dream_string(string, owner, user)
    output = string.gsub('<', '&lt;').gsub('>', '&gt;')
    output = parse_dream_links output, user
    output = parse_names output, user == owner unless owner.nil?
    "<p>#{output}</p>\n"
  end

  # Parse string as string from common text
  #
  # @param [String] string
  # @param [User] user
  # @return [String]
  def parse_comment_string(string, user = nil)
    output = string.gsub('<', '&lt;').gsub('>', '&gt;')
    output = parse_dream_links output, user
    output = parse_post_links output
    output = parse_pattern_links output
    "<p>#{output}</p>\n"
  end
end
