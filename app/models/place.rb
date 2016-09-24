class Place < ApplicationRecord
  include HasOwner

  belongs_to :user

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:user_id]

  # @param [User] user
  def self.page_for_owner(user)
    owned_by(user).order('dreams_count desc, name asc')
  end

  def self.entity_parameters
    %i(name description)
  end
end
