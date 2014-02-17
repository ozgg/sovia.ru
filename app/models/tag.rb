class Tag < ActiveRecord::Base
  has_many :entry_tags
  has_many :entries, through: :entry_tags

  validates_presence_of :name
  validates_uniqueness_of :canonical_name
  before_validation :normalize_name, :create_canonical_name, :create_letter

  def self.match_by_name(name)
    self.find_by_canonical_name(self.new.canonize name)
  end

  def canonize(input)
    downcased = input.mb_chars.downcase.to_s
    canonized = downcased.gsub(/[^a-zа-я0-9ё]/, '')
    canonized.empty? ? downcased.strip : canonized
  end

  def parsed_description
    text = description ? description.strip : ''
    if text.length > 0
      '<p>' + text.gsub(/(\r?\n)+/, '</p><p>') + '</p>'
    else
      ''
    end
  end

  private

  def normalize_name
    self.name.squish!
  end

  def create_canonical_name
    self.canonical_name = canonize name
  end

  def create_letter
    self.letter = canonical_name.first.mb_chars.upcase.to_s
  end
end
