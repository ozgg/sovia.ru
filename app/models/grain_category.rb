class GrainCategory < ApplicationRecord
  include RequiredUniqueName

  has_many :grains, dependent: :nullify

  scope :visible, -> { where deleted: false }

  def self.page_for_administration
    ordered_by_name
  end

  def self.page_for_users
    visible.ordered_by_name
  end

  def self.entity_parameters
    %i(name)
  end
end
