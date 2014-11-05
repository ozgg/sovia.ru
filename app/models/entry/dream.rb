class Entry::Dream < Entry

  def self.random_dream
    max_offset = public_entries.count - 1
    offset = Time.now.getutc.to_i % max_offset
    public_entries.offset(offset).first
  end

  def matching_tag(name)
    Tag::Dream.match_or_create_by_name(name)
  end
end
