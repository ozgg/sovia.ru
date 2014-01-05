class Dream < Post
  def self.recent
    where(entry_type: TYPE_DREAM).order('id desc')
  end
end
