class Grain < ActiveRecord::Base
  include HasLanguage
  include HasOwner
  include HasNameWithSlug

  belongs_to :user
  belongs_to :pattern
  has_many :dream_grains, dependent: :destroy
  has_many :dreams, through: :dream_grains

  enum category: [:person, :place, :item, :event, :action, :creature]

  validates_presence_of :user_id
  validates_uniqueness_of :slug, scope: [:user_id, :language_id]

  mount_uploader :image, ImageUploader

  def self.string_to_array(names, language, user)
    list = names.split(',').select { |name| !name.blank? }.map do |name|
      self.match_or_create_by_name(name.squish, language, user)
    end
    list.uniq
  end

  def self.match_by_name(name, language, user)
    find_by user: user, language: language, slug: Canonizer.canonize(name)
  end

  def self.match_or_create_by_name(name, language, user)
    grain = self.match_by_name name, language, user
    grain || self.create_pair(user, language, name, name)
  end

  def self.match_as_pair(long_name, language, user)
    grain = self.match_or_create_by_name long_name, language, user
    grain.update pattern: Pattern.match_or_create_by_name(grain.name, language)
    grain
  end

  # /([^(]+)\s*(?:\(([^)]*)\))?/

  protected

  def self.create_pair(user, language, name, pattern_name)
    grain = self.create(user: user, language: language, name: name)
    grain.update pattern: Pattern.match_or_create_by_name(pattern_name, language)
    grain
  end
end
