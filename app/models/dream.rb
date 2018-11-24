# frozen_string_literal: true

# Dream of user
#
# Attributes:
#   agent_id [Agent], optional
#   body [Text]
#   created_at [DateTime]
#   interpreted [Boolean]
#   ip [Inet], optional
#   lucidity [Integer]
#   needs_interpretation [Boolean]
#   privacy [Integer]
#   sleep_place_id [SleepPlace], optional
#   title [String], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   visible [Boolean]
class Dream < ApplicationRecord
  belongs_to :user
  belongs_to :sleep_place
  belongs_to :agent
end
