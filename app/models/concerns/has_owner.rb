module HasOwner
  extend ActiveSupport::Concern

  included do
    belongs_to :owner, polymorphic: true
  end

  def owned_by?(person)
    owner == person
  end
end