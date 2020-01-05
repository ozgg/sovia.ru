# frozen_string_literal: true

# Service for user
#
# Attributes:
#   created_at [DateTime]
#   data [jsonb]
#   end_date [date], optional
#   quantity [integer]
#   service_id [Service]
#   updated_at [DateTime]
#   user_id [User]
class UserService < ApplicationRecord
  belongs_to :user
  belongs_to :service, counter_cache: :users_count
end
