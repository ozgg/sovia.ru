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

  def link_to_dream(dream)
    link_to dream.parsed_title, entry_dream_path(dream)
  end

  def comment_url(comment)
    parameters = {
        id: comment.entry.id,
        uri_title: comment.entry.url_title || 'bez-nazvaniya',
        anchor: "comment-#{comment.id}"
    }
    if entry.is_a? Entry::Article
      verbose_entry_articles_url parameters
    elsif entry.is_a? Entry::Dream
      verbose_entry_dreams_url parameters
    elsif entry.is_a? Entry::Post
      verbose_entry_posts_url parameters
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
    end
  end
end
