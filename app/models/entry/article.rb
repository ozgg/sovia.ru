class Entry::Article < Entry
  after_initialize :set_specific_fields
  validates_presence_of :user, :title

  private

  def set_specific_fields
    self.privacy = PRIVACY_NONE
  end
end
