class Entry::Thought < Entry

  def matching_tag(name)
    Tag::Thought.match_or_create_by_name(name)
  end
end
