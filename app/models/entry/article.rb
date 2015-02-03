class Entry::Article < Entry
  after_initialize :set_specific_fields
  validates_presence_of :user, :title

  def matching_tag(name)
    Tag::Article.match_or_create_by_name(name)
  end

  private

  def set_specific_fields
    self.privacy = PRIVACY_NONE
  end
end
