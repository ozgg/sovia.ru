class Agent < ActiveRecord::Base
  belongs_to :browser, counter_cache: true

  has_many :users, dependent: :nullify
  has_many :codes, dependent: :nullify
  has_many :tokens, dependent: :nullify
  has_many :posts, dependent: :nullify
  has_many :dreams, dependent: :nullify
  has_many :questions, dependent: :nullify
  has_many :patterns, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :side_notes, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name

  # Get instance of Agent for given string
  #
  # Trims agent name upto 255 characters
  #
  # @param [String] name
  # @return [Agent]
  def self.for_string(name)
    criterion = { name: name[0..254] }
    self.find_by(criterion) || self.create(criterion)
  end
end
