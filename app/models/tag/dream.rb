class Tag::Dream < Tag
  def self.recently_updated
    self.where('description is not null').order('updated_at desc').first(10)
  end

  def self.trends
    tags    = {}
    Entry::Dream.order('id desc').first(50).each do |dream|
      dream.tags.each do |tag|
        unless tags.has_key? tag
          tags[tag] = 0
        end
        tags[tag] += 1
      end
    end

    tags.sort_by { |tag, weight| weight }.reverse[0..9]
  end
end
