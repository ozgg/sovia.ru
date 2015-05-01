module HasPrivacy
  extend ActiveSupport::Concern

  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  included do
    validates_inclusion_of :privacy, in: [PRIVACY_NONE, PRIVACY_USERS, PRIVACY_OWNER]
  end

  def visible_to?(looker)
    case privacy
      when PRIVACY_NONE
        true
      when PRIVACY_USERS
        !looker.nil?
      else
        user == looker
    end
  end
end
