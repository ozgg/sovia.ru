module HasPrivacy
  extend ActiveSupport::Concern

  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  included do
  end
end
