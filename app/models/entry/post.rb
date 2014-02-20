class Entry::Post < Entry

  def matching_tag(name)
    Tag::Post.match_or_create_by_name(name)
  end
end
