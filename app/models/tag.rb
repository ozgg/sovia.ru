class Tag < ActiveRecord::Base
  belongs_to :entry_type
  has_many :entry_tags
  has_many :entries, through: :entry_tags

  validates_presence_of :name
  validates_uniqueness_of :canonical_name
  before_validation :normalize_name, :create_canonical_name, :create_letter

  def self.match_by_name(name, entry_type)
    self.find_by(canonical_name: self.canonize(name), entry_type: entry_type)
  end

  def self.match_or_create_by_name(name, entry_type)
    self.find_or_create_by(canonical_name: self.canonize(name), entry_type: entry_type)
  end

  def self.canonize(input)
    lowered   = input.mb_chars.downcase.to_s.strip
    canonized = lowered.gsub(/[^a-zа-я0-9ё]/, '')
    canonized.empty? ? lowered : canonized
  end

  private

  def normalize_name
    self.name.squish!
  end

  def create_canonical_name
    self.canonical_name = Tag.canonize name
  end

  def create_letter
    self.letter = canonical_name.first.mb_chars.upcase.to_s
  end
end
