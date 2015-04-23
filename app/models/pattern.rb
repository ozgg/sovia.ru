class Pattern < ActiveRecord::Base
  include HasLanguage

  before_validation :prepare_code!

  validates_presence_of :name, :code
  validates_uniqueness_of :code, scope: [:language_id]

  mount_uploader :image, ImageUploader

  def self.to_code(name)
    stripped = name.mb_chars.downcase.to_s.strip.gsub(/[^a-zа-я0-9ё]/, '')
    stripped.blank? ? nil : stripped
  end

  def self.match_by_name(language, name)
    find_by language: language, code: self.to_code(name)
  end

  def self.match_or_create_by_name(language, name)
    self.match_by_name(language, name) || create(language: language, name: name)
  end

  def prepare_code!
    self.code = Pattern.to_code self.name
  end
end
