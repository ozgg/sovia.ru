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

  def link_to_dream(dream)
    link_to dream.parsed_title, entry_dream_path(dream)
  end

  def comment_url(comment)
    entry  = comment.entry
    anchor = "comment-#{comment.id}"
    if entry.is_a? Entry::Article
      entry_article_url entry, anchor: anchor
    elsif entry.is_a? Entry::Dream
      entry_dream_url entry, anchor: anchor
    elsif entry.is_a? Entry::Post
      entry_post_url entry, anchor: anchor
    else
      "Entry #{entry.id}"
    end
  end
end
