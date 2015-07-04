class Grain < ActiveRecord::Base
  include HasUser
  include HasCoordinates
  include HasLanguage

  belongs_to :pattern
  before_validation :prepare_code!
  validates_presence_of :user, :name, :code
  validates_uniqueness_of :code, scope: [:user_id]

  mount_uploader :image, PersonalUploader

  enum category: [:person, :place, :event, :item, :creature, :activity]

  def self.to_code(name)
    stripped = name.mb_chars.downcase.to_s.strip.gsub(/[^a-zа-я0-9ё]/, '')
    stripped.blank? ? nil : stripped
  end

  def self.match_by_name(user, name)
    find_by user: user, code: self.to_code(name)
  end

  def self.match_or_create_by_name(user, name, pattern = nil)
    self.match_by_name(user, name) || create(user: user, name: name, pattern: pattern)
  end

  def prepare_code!
    self.code = Grain.to_code self.name
  end

  def pattern_name
    self.pattern.nil? ? '' : self.pattern.name
  end
end
