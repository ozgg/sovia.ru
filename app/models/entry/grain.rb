class Entry::Grain < Entry
  def matching_tag(name)
    Tag::Grain.match_or_create_by_name(name)
  end
end
