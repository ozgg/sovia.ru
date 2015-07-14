class DreamFactor < ActiveRecord::Base
  belongs_to :dream

  enum factor: [:activity, :stress, :food, :noise, :temperature, :comfort, :tonic, :alcohol, :substances]

  validates_presence_of :dream_id
  validates_uniqueness_of :factor, scope: :dream_id
end
