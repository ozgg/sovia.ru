class Pattern < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  PER_PAGE = 20

  toggleable :described

  has_many :pattern_words, dependent: :destroy
  has_many :words, through: :pattern_words
  has_many :comments, as: :commentable

  mount_uploader :image, PatternImageUploader

  scope :visible, -> { where deleted: false }
  scope :ordered_by_popularity, -> { order 'dreams_count desc, name asc' }
  scope :described, -> (flag) { where described: flag.to_i > 0 unless flag.blank? }
  scope :filtered, -> (f) { described(f[:described]).with_name(f[:name]) }

  # @param [Integer] page
  # @param [Hash] filters
  def self.page_for_administration(page, filters = {})
    filtered(filters).ordered_by_popularity.page(page).per(PER_PAGE)
  end

  # @param [Integer] page
  def self.page_for_visitors(page)
    visible.ordered_by_name.page(page).per(PER_PAGE)
  end

  def self.entity_parameters
    %i(image name essence description described)
  end

  # @param [String] string
  def self.match_by_name(string)
    find_by('name ilike ?', string)
  end

  # @param [String] string
  def words_string=(string)
    new_word_ids = []
    string.mb_chars.downcase.to_s.strip.split(/,\s*/).reject { |s| s.blank? }.uniq.each do |body|
      new_word_ids << Word.find_or_create_by(body: body).id
    end
    self.word_ids = new_word_ids
  end

  def words_string
    words.map { |word| word.body }.join(', ')
  end
end
