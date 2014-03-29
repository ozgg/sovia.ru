module ApplicationHelper

  def user_link(user)
    if user.nil?
      t('anonymous')
    else
      user.login
    end
  end

  def user_avatar(user)
    if user.nil? || user.email.nil? || user.email.empty?
      image_tag 'smile.png'
    else
      hash = Digest::MD5.hexdigest(user.email.downcase)
      url  = "http://www.gravatar.com/avatar/#{hash}?s=100&amp;d=identicon"
      image_tag url
    end
  end

  def profile_avatar(user)
    if user.nil?
      image_tag 'fallback/avatar/default.png'
    else
      image_tag user.avatar.url
    end
  end

  def entry_avatar(user)
    attributes = { width: 100, height: 100 }
    if user.nil?
      image_tag 'fallback/avatar/entry_default.png', attributes
    else
      image_tag user.avatar.entry.url, attributes
    end
  end

  def comment_avatar(user)
    attributes = { width: 50, height: 50 }
    if user.nil?
      image_tag 'fallback/avatar/comment_default.png', attributes
    else
      image_tag user.avatar.comment.url, attributes
    end
  end

  def link_to_dream(dream)
    link_to dream.parsed_title, entry_dream_path(dream)
  end

  def tagged_entries_path(tag)
    parameters = { tag: tag.uri_name }
    attributes = { rel: 'tag' }
    if tag.is_a? Tag::Dream
      link_to tag.name, tagged_entry_dreams_path(parameters), attributes
    elsif tag.is_a? Tag::Article
      link_to tag.name, tagged_entry_articles_path(parameters), attributes
    elsif tag.is_a? Tag::Post
      link_to tag.name, tagged_entry_posts_path(parameters), attributes
    elsif tag.is_a? Tag::Thought
      link_to tag.name, tagged_entry_thoughts_path(parameters), attributes
    else
      tag.name
    end
  end

  def comment_url(comment)
    entry = comment.entry
    parameters = {
        id:        entry.id,
        uri_title: entry.url_title || 'bez-nazvaniya',
        anchor:    "comment-#{comment.id}"
    }
    if entry.is_a? Entry::Article
      verbose_entry_articles_url parameters
    elsif entry.is_a? Entry::Dream
      verbose_entry_dreams_url parameters
    elsif entry.is_a? Entry::Post
      verbose_entry_posts_url parameters
    elsif entry.is_a? Entry::Thought
      verbose_entry_thoughts_url parameters
    else
      "Entry #{entry.id}"
    end
  end

  def verbose_entry_path(entry)
    parameters = {
        id:        entry.id,
        uri_title: entry.url_title || 'bez-nazvaniya'
    }
    if entry.is_a? Entry::Article
      verbose_entry_articles_path(parameters)
    elsif entry.is_a? Entry::Dream
      verbose_entry_dreams_path(parameters)
    elsif entry.is_a? Entry::Post
      verbose_entry_posts_path(parameters)
    elsif entry.is_a? Entry::Thought
      verbose_entry_thoughts_path(parameters)
    end
  end

  def verbose_entry_url(entry)
    parameters = {
        id:        entry.id,
        uri_title: entry.url_title || 'bez-nazvaniya'
    }
    if entry.is_a? Entry::Article
      verbose_entry_articles_url(parameters)
    elsif entry.is_a? Entry::Dream
      verbose_entry_dreams_url(parameters)
    elsif entry.is_a? Entry::Post
      verbose_entry_posts_url(parameters)
    elsif entry.is_a? Entry::Thought
      verbose_entry_thoughts_url(parameters)
    end
  end

  def parse_body(body, allow_raw = false)
    output = ''
    body.strip.split(/(?:\r?\n)+/).each do |fragment|
      fragment.gsub!(/(\S{30})/, '\1&shy;')
      unless allow_raw
        fragment.gsub!('<', '&lt;')
        fragment.gsub!('>', '&gt;')
      end
      link_dreambook_symbols(fragment)
      link_entries(fragment)
      find_links(fragment)
      if fragment.match(/\A<(?:p|li|h|ol|ul)/)
        output += fragment
      else
        output += "<p>#{fragment}</p>"
      end
    end

    output
  end

  def link_dreambook_symbols(fragment)
    pattern = /[\[<]symbol name="(?<name>[^"]+)"[^\]>]*[\]>]/
    fragment.gsub! pattern do |chunk|
      match = pattern.match chunk
      tag   = Tag::Dream.match_by_name(match[:name])
      if tag.nil?
        '<span class="not-found">' + match[:name] + '</span>'
      else
        link_to(match[:name], dreambook_word_path(letter: tag.letter, word: tag.name))
      end
    end
  end

  def link_entries(fragment)
    pattern = /\[(?:entry|article|dream|post)\s+id="(?<id>[^"]{1,8})"[^\]]*\]/
    fragment.gsub! pattern do |chunk|
      match = pattern.match chunk
      entry = Entry::find_by(id: match[:id])
      if entry.nil?
        "<span class=\"not-found\">#{match[:id]}</span>"
      else
        '&laquo;' + link_to(entry.parsed_title, verbose_entry_path(entry)) + '&raquo;'
      end
    end
  end

  def find_links(fragment)
    pattern = /(?:\[(?<href>(?:https?:\/\/|\/)[a-zA-Z0-9\.\/?=&%+\-_]+)\]\((?<text>[^\)]+)\))/
    fragment.gsub! pattern do |chunk|
      match = pattern.match chunk
      '<a href="' + match[:href] + '">' + match[:text] + '</a>'
    end
  end
end
