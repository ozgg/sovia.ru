class User < ActiveRecord::Base
  include HasLanguage
  include HasTrace

  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :user_languages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :deeds, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :patterns, dependent: :nullify
  has_many :grains, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :dreams, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :side_notes, dependent: :destroy

  enum gender: [:female, :male]
  enum network: [:native, :vk, :twitter, :fb, :mail_ru]

  before_validation :normalize_email, :normalize_screen_name

  validates_presence_of :uid
  validates_uniqueness_of :uid, scope: [:network]
  validate :uid_should_be_valid
  validate :email_should_be_reasonable

  mount_uploader :image, AvatarUploader

  def self.with_long_uid(long_uid)
    parts = long_uid.split('-')
    if parts.length > 1
      code = parts.shift
      find_by(network: networks[code], uid: parts.join('-')) if networks.has_key?(code)
    else
      find_by uid: long_uid
    end
  end

  def long_uid
    prefix = native? ? '' : network + '-'
    prefix + uid
  end

  def has_role?(role)
    UserRole.user_has_role? self, role
  end

  def add_role(role)
    if UserRole.role_exists? role
      UserRole.create user: self, role: role unless has_role? role
    end
  end

  def remove_role(role)
    UserRole.destroy_all(user: self, role: UserRole.roles[role]) if UserRole.role_exists? role
  end

  # @param [Hash] roles
  def roles=(roles)
    roles.each do |role, flag|
      flag.to_i > 0 ? add_role(role) : remove_role(role)
    end
  end

  def speaks_language?(language)
    UserLanguage.user_speaks_language? self, language
  end

  def add_language(language)
    UserLanguage.create user: self, language: language
  end

  def remove_language(language)
    UserLanguage.destroy_all(user: self, language: language)
  end

  # @param [Hash] language_ids
  def language_ids=(language_ids)
    language_ids.each do |language_id, flag|
      language = Language.find language_id
      flag.to_i > 0 ? add_language(language) : remove_language(language)
    end
  end

  def follows?(user)
    user.is_a?(User) && (user.id == self.id)
  end

  protected

  def normalize_screen_name
    self.uid = screen_name.downcase if native? && !screen_name.blank?
  end

  def normalize_email
    email.downcase! unless email.nil?
  end

  def email_should_be_reasonable
    unless email.nil? || email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
      errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.unreasonable'))
    end
  end

  def uid_should_be_valid
    if native?
      pattern = /\A[a-z0-9_]{1,30}\z/
      errors.add(:uid, I18n.t('activerecord.errors.models.user.attributes.uid.invalid')) unless uid =~ pattern
    end
  end
end
