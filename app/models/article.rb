class Article < Post
  def self.recent
    where(entry_type: TYPE_ARTICLE).order('id desc')
  end
end
