class Entry::Thought < Entry
  validates_presence_of :user
  
  def matching_tag(name)
    Tag::Thought.match_or_create_by_name(name)
  end
end
