class Entry::Dream < Entry

  def self.random_dream
    max_id = public_dreams.maximum(:id)
    public_dreams.where("id >= #{rand(max_id)}").first
  end

  def self.public_dreams
    where(privacy: PRIVACY_NONE)
  end

  def matching_tag(name)
    Tag::Dream.match_or_create_by_name(name)
  end
end
