class Article < Entry
  after_initialize :set_specific_fields
  validates_presence_of :user, :title

  def self.recent
    where(entry_type: TYPE_ARTICLE).order('id desc')
  end

  private

  def set_specific_fields
    self.entry_type ||= TYPE_ARTICLE
    self.privacy    ||= PRIVACY_NONE
  end
end
