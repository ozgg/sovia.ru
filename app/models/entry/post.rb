class Entry::Post < Entry
  validates_presence_of :user

  def matching_tag(name)
    Tag::Post.match_or_create_by_name(name)
  end
end
