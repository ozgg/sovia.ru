class Entry::Grain < Entry
  after_initialize :set_specific_fields

  def matching_tag(name)
    Tag::Grain.match_or_create_by_name(name)
  end

  private

  def set_specific_fields
    self.privacy = PRIVACY_OWNER
  end
end
