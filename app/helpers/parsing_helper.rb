module ParsingHelper

  # Prepare dream text for views
  #
  # @param [Dream] dream
  # @param [User] current_user
  # @return [String]
  def prepare_dream_text(dream, current_user)
    buffer = ''
    show_names = dream.owned_by? current_user
    dream.body.split("\n").each { |string| buffer += parse_dream_string string.squish, current_user, show_names }
    buffer
  end

  # Prepare comment text for views
  #
  # @param [Comment] comment
  # @param [User] current_user
  # @return [String]
  def prepare_comment_text(comment, current_user)
    buffer = ''
    comment.body.split("\n").each { |string| buffer += parse_comment_string string.squish, current_user }
    buffer
  end

  # Prepare question text for views
  #
  # @param [Question] question
  # @param [User] current_user
  # @return [String]
  def prepare_question_text(question, current_user)
    buffer = ''
    question.body.split("\n").each { |string| buffer += parse_question_string string.squish, current_user }
    buffer
  end

  # Prepare post text for views
  #
  # @param [Post] post
  # @return [String]
  def prepare_post_text(post)
    simple_format post.body
  end

  # Prepare pattern description for views
  #
  # @param [Pattern] pattern
  # @return [String]
  def prepare_pattern_text(pattern)
    buffer = ''
    pattern.description.to_s.split("\n").each { |string| buffer += parse_pattern_string string.squish }
    buffer
  end

  # Parse fragments like [dream 123](link text)
  #
  # @param [String] string
  # @param [User] current_user
  # @return [String]
  def parse_dream_links(string, current_user)
    pattern = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/
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

  # Parse fragments like [post 123](link text)
  #
  # @param [String] string
  # @return [String]
  def parse_post_links(string)
    pattern = /\[post (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/
    string.gsub pattern do |chunk|
      match = pattern.match chunk
      post = Post.find_by id: match[:id]
      if post.is_a? Post
        link_text = match[:text].blank? ? post.title : match[:text]
        "«#{link_to link_text, post, title: post.title}»"
      else
        '<span class="not-found">post ' + match[:id] + '</span>'
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
      match = regex.match chunk
      pattern = Pattern.match_by_name match[:body]
      if pattern.is_a? Pattern
        link_text = match[:text].blank? ? match[:body] : match[:text]
        link_to link_text, dreambook_word_path(letter: pattern.letter, word: pattern.name)
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

  # Parse string as string from dream
  #
  # @param [String] string
  # @param [User] current_user
  # @param [Boolean] show_names
  # @return [String]
  def parse_dream_string(string, current_user, show_names)
    if string.blank?
      ''
    else
      "<p>#{fragments_for_dream(string, current_user, show_names)}</p>"
    end
  end

  # Parse fragments available in dreams
  #
  # @param [String] string
  # @param [User] current_user
  # @param [Boolean] show_names
  def fragments_for_dream(string, current_user, show_names)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    string_with_name = parse_names quoted_string, show_names
    parse_dream_links string_with_name, current_user
  end

  # Parse string as string from comment
  #
  # @param [String] string
  # @param [User] current_user
  # @return [String]
  def parse_comment_string(string, current_user)
    if string.blank?
      ''
    else
      "<p>#{fragments_for_comment(string, current_user)}</p>"
    end
  end

  # Parse fragments available for comments
  #
  # @param [String] string
  # @param [User] current_user
  # @return [String]
  def fragments_for_comment(string, current_user)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    processed_string = parse_dream_links quoted_string, current_user
    processed_string = parse_pattern_links processed_string
    parse_post_links processed_string
  end

  # Parse string as string from question
  #
  # @param [String] string
  # @param [User] current_user
  # @return [String]
  def parse_question_string(string, current_user)
    if string.blank?
      ''
    else
      "<p>#{fragments_for_question(string, current_user)}</p>"
    end
  end

  # Parse fragments available for questions
  #
  # @param [String] string
  # @param [User] current_user
  # @return [String]
  def fragments_for_question(string, current_user)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    processed_string = parse_dream_links quoted_string, current_user
    processed_string = parse_pattern_links processed_string
    parse_post_links processed_string
  end

  # Parse string as string from pattern description
  #
  # @param [String] string
  # @return [String]
  def parse_pattern_string(string)
    if string.blank?
      ''
    else
      "<p>#{fragments_for_pattern(string)}</p>"
    end
  end

  # Parse fragments available for patterns
  #
  # @param [String] string
  def fragments_for_pattern(string)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    parse_pattern_links quoted_string
  end
end
