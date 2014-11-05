class Entry::Dream < Entry

  def self.random_dream
    max_id  = (public_entries.maximum(:id) || 0) + 1
    rand_id = Time.now.getutc.to_i % max_id
    public_entries.where("id <= #{rand_id}").last
  end

  def matching_tag(name)
    Tag::Dream.match_or_create_by_name(name)
  end
end
