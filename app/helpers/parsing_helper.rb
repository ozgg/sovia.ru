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

  def parse_pattern_links(string)
    regex = /\[\[(?<body>[^\]]{1,50})\]\](?:\((?<text>[^)]{1,64})\))?/
    string.gsub regex do |chunk|
      match = regex.match chunk
      pattern = Pattern.match_by_name match[:body]
      if pattern.is_a? Pattern
        link_text = match[:text].blank? ? pattern.name : match[:text]
        link_to link_text, dreambook_word_path(letter: pattern.letter, word: pattern.name)
      else
        '<span class="not-found">' + match[:body] + '</span>'
      end
    end
  end

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

  def parse_dream_string(string, current_user, show_names)
    if string.blank?
      ''
    else
      "<p>#{fragments_for_dream(string, current_user, show_names)}</p>"
    end
  end

  def fragments_for_dream(string, current_user, show_names)
    quoted_string = string.gsub('<', '&lt;').gsub('>', '&gt;')
    string_with_name = parse_names quoted_string, show_names
    parse_dream_links string_with_name, current_user
  end
end
