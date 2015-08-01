class PatternLink < ActiveRecord::Base
  belongs_to :pattern
  belongs_to :target, class_name: Pattern.to_s

  enum category: [:see_instead, :see_also, :expands, :expanded_by]

  validates_presence_of :pattern_id, :target_id
  validates_uniqueness_of :category, scope: [:pattern_id, :target_id]

  scope :in_category, -> (category) { where category: categories[category] if categories.has_key? category }

  def self.by_triplet(category, pattern, target)
    parameters = { category: self.categories[category], pattern: pattern, target: target }
    find_by(parameters) || create(parameters)
  end
end
