class Dream < Post
  after_initialize :set_specific_fields

  def self.recent
    where(entry_type: TYPE_DREAM).order('id desc')
  end

  private

  def set_specific_fields
    self.entry_type ||= TYPE_DREAM
  end
end
