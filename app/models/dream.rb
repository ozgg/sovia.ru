class Dream < Entry
  after_initialize :set_specific_fields

  def self.recent
    where(entry_type: TYPE_DREAM).order('id desc')
  end

  def self.random_dream
    max_id = public_dreams.maximum(:id)
    public_dreams.where("id >= #{rand(max_id)}").first
  end

  private

  def set_specific_fields
    self.entry_type ||= TYPE_DREAM
  end

  def self.public_dreams
    where(entry_type: TYPE_DREAM, privacy: PRIVACY_NONE)
  end
end
