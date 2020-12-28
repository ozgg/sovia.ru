# frozen_string_literal: true

# Post
# 
# Attributes:
#   body [text]
#   created_at [DateTime]
#   data [jsonb]
#   featured [boolean]
#   lead [text], optional
#   publication_time [datetime]
#   simple_image_id [SimpleImage], optional
#   slug [string]
#   source_link [string], optional
#   source_name [string], optional
#   title [string]
#   updated_at [DateTime]
#   user_id [User]
#   uuid [uuid]
#   visible [boolean]
class Post < ApplicationRecord
  include Checkable
  include HasOwner
  include HasSimpleImage
  include HasUuid

  TITLE_LIMIT = 250
  LEAD_LIMIT = 1000

  belongs_to :user
end
