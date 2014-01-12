class EntryTag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :canonical_name
  before_validation :create_canonical_name, :create_letter

  def self.match_by_name(name)
    self.find_by_canonical_name(self.new.canonize name)
  end

  def canonize(input)
    input.mb_chars.downcase.to_s.gsub(/[^a-zа-я0-9ё]/, '')
  end

  private

  def create_canonical_name
    self.canonical_name = canonize name
  end

  def create_letter
    self.letter = canonical_name.first.mb_chars.upcase.to_s
  end
end
