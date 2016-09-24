class Place < ApplicationRecord
  include HasOwner

  belongs_to :user

  validates_presence_of :name
  validates_uniqueness_of :name, scope: [:user_id]

  def self.page_for_owner
    order('dreams_count desc, name asc')
  end

  def self.entity_parameters
    %i(name description)
  end
end
