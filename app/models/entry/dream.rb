class Entry::Dream < Entry

  def self.random_dream
    max_id = public_entries.maximum(:id) + 1
    public_entries.where("id >= #{rand(max_id)}").first
  end

  def matching_tag(name)
    Tag::Dream.match_or_create_by_name(name)
  end
end
