class Tag::Dream < Tag
  def self.recently_updated
    self.where('description is not null').order('updated_at desc').first(10)
  end
end
