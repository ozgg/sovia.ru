class User < ApplicationRecord
  include Toggleable

  EMAIL_PATTERN     = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i
  SLUG_PATTERN      = /\A[a-z0-9_]{1,30}\z/
  NETWORK_SEPARATOR = '-'
  PER_PAGE          = 25
  PLACE_LIMIT       = 5

  METRIC_REGISTRATION  = 'users.registration.hit'
  METRIC_AUTHORIZATION = 'users.authorization.hit'

  toggleable %i(email_confirmed phone_confirmed allow_mail allow_login bot)

  belongs_to :agent, optional: true
  has_many :user_roles, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :codes, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :places, dependent: :destroy
  has_many :grains, dependent: :destroy
  has_many :dreams, dependent: :destroy

  has_secure_password

  enum network: [:native, :vkontakte, :twitter, :facebook, :mail_ru]
  enum gender: [:female, :male]

  before_validation :normalize_screen_name

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: [:network]
  validate :slug_should_be_valid
  validate :email_should_be_reasonable

  mount_uploader :image, AvatarUploader

  scope :native_users, -> { where(network: User.networks[:native]) }
  scope :bots, -> (flag) { where bot: flag.to_i > 0 unless flag.blank? }
  scope :network, -> (network) { where network: network unless network.blank? }
  scope :name_like, -> (val) { where 'name ilike ?', "%#{val}%" unless val.blank? }
  scope :email_like, -> (val) { where 'email ilike ?', "%#{val}%" unless val.blank? }
  scope :with_email, -> (email) { where 'email ilike ?', email }
  scope :screen_name_like, -> (val) { where 'screen_name ilike ?', "%#{val}%" unless val.blank? }
  scope :filtered, -> (f) { name_like(f[:name]).email_like(f[:email]).screen_name_like(f[:screen_name]) }

  # @param [Integer] page
  # @param [Hash] filter
  def self.page_for_administration(page, filter = {})
    bots(filter[:bots]).network(filter[:network]).filtered(filter).order('slug asc').page(page).per(PER_PAGE)
  end

  def self.profile_parameters
    %i(image name patronymic surname birthday gender allow_mail)
  end

  def self.sensitive_parameters
    %i(email phone password password_confirmation)
  end

  # Параметры при регистрации
  def self.new_profile_parameters
    profile_parameters + sensitive_parameters + %i(screen_name)
  end

  # Параметры для администрирования
  def self.entity_parameters
    new_profile_parameters + %i(slug bot allow_login email_confirmed phone_confirmed notice)
  end

  # Параметры для создания в админке
  def self.creation_parameters
    entity_parameters + %i(network)
  end

  # @param [String] long_slug
  def self.with_long_slug(long_slug)
    parts = long_slug.split NETWORK_SEPARATOR
    if parts.length > 1
      code = parts.shift
      find_by(network: networks[code], slug: parts.join(NETWORK_SEPARATOR)) if networks.has_key?(code)
    else
      find_by slug: long_slug
    end
  end

  def long_slug
    prefix = native? ? '' : network + NETWORK_SEPARATOR
    prefix + slug
  end

  def profile_name
    screen_name || slug
  end

  def name_for_letter
    name || profile_name
  end

  # @param [Array] suitable_roles
  def has_role?(*suitable_roles)
    UserRole.user_has_role? self, *suitable_roles
  end

  # @param [Symbol] role
  def add_role(role)
    if UserRole.role_exists? role
      UserRole.create user: self, role: role unless has_role? role
    end
  end

  # @param [Symbol] role
  def remove_role(role)
    UserRole.where(user: self, role: UserRole.roles[role]).destroy_all if UserRole.role_exists? role
  end

  # @param [Hash] roles
  def roles=(roles)
    roles.each do |role, flag|
      flag.to_i > 0 ? add_role(role) : remove_role(role)
    end
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  # @param [User] user
  def follows?(user)
    user == self
  end

  def native_user
    User.native.find_by(id: native_id) unless native_id.nil?
  end

  protected

  def normalize_screen_name
    self.slug = screen_name.downcase if native? && !screen_name.blank?
  end

  def email_should_be_reasonable
    if email.blank?
      self.email = nil
    else
      errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.unreasonable')) unless email =~ EMAIL_PATTERN
    end
  end

  def slug_should_be_valid
    if native?
      errors.add(:screen_name, I18n.t('activerecord.errors.models.user.attributes.slug.invalid')) unless slug =~ SLUG_PATTERN
    end
  end
end
