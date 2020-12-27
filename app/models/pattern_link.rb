# frozen_string_literal: true

# Link between patterns
#
# Attributes:
#   other_pattern_id [Pattern]
#   pattern_id [Pattern]
class PatternLink < ApplicationRecord
  belongs_to :pattern
  belongs_to :other_pattern, class_name: Pattern.to_s

  validates_uniqueness_of :other_pattern_id, scope: :pattern_id
end
