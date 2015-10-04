module ParsingHelper

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
end
