module HasOwner
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
  end
end
