# frozen_string_literal: true

# Message in interpretation dialog
# 
# Attributes:
#   body [text]
#   created_at [DateTime]
#   from_user [boolean]
#   interpretation_id [Interpretation]
#   updated_at [DateTime]
#   uuid [uuid]
class InterpretationMessage < ApplicationRecord
  include HasUuid

  BODY_LIMIT = 5000

  belongs_to :interpretation

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :ordered, -> { order('id asc') }

  def self.entity_parameters
    %i[body]
  end
end
