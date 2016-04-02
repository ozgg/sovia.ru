class User < ActiveRecord::Base
  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i
  SLUG_PATTERN  = /\A[a-z0-9_]{1,20}\z/

  PER_PAGE = 25

  has_many :user_roles, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :codes, dependent: :destroy

  has_secure_password

  enum network: [:native, :facebook, :twitter, :vkontakte]
  enum gender: [:female, :male]

  before_validation :normalize_screen_name

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: [:network]
  validate :slug_should_be_valid
  validate :email_should_be_reasonable

  mount_uploader :image, AvatarUploader

  scope :bots, -> (flag) { where bot: flag.to_i > 0 unless flag.blank? }
  scope :network, -> (network) { where network: network unless network.blank? }

  def self.page_for_administration(page, filter)
    self.order('network asc, slug asc').bots(filter[:bots]).network(filter[:network]).page(page).per(PER_PAGE)
  end

  # Параметры для администрирования
  def self.entity_parameters
    %i(
      slug email screen_name name image gender bot allow_login password password_confirmation email_confirmed allow_mail
    )
  end

  # @param [String] long_slug
  def self.with_long_slug(long_slug)
    parts = long_slug.split('-')
    if parts.length > 1
      code = parts.shift
      find_by(network: networks[code], slug: parts.join('-')) if networks.has_key?(code)
    else
      find_by slug: long_slug
    end
  end

  def long_slug
    prefix = native? ? '' : network + '-'
    prefix + slug
  end

  def profile_name
    screen_name || slug
  end

  def name_for_letter
    name || profile_name
  end

  # @param [Symbol] role
  def has_role?(role)
    UserRole.user_has_role? self, role
  end

  # @param [Symbol] role
  def add_role(role)
    if UserRole.role_exists? role
      UserRole.create user: self, role: role unless has_role? role
    end
  end

  # @param [Symbol] role
  def remove_role(role)
    UserRole.destroy_all(user: self, role: UserRole.roles[role]) if UserRole.role_exists? role
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

  protected

  def normalize_screen_name
    self.slug = screen_name.downcase if native? && !screen_name.blank?
  end

  def email_should_be_reasonable
    unless email.nil? || email =~ EMAIL_PATTERN
      errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.unreasonable'))
    end
  end

  def slug_should_be_valid
    if native?
      errors.add(:screen_name, I18n.t('activerecord.errors.models.user.attributes.slug.invalid')) unless slug =~ SLUG_PATTERN
    end
  end
end
