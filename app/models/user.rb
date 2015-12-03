class User < ActiveRecord::Base
  include HasTrace
  include HasGender

  has_secure_password

  has_many :user_roles, dependent: :destroy
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
  belongs_to :inviter, class_name: User.to_s

  enum network: [:native, :vk, :twitter, :fb, :mail_ru]

  before_validation :normalize_email, :normalize_screen_name

  validates_presence_of :uid
  validates_uniqueness_of :uid, scope: [:network]
  validate :uid_should_be_valid
  validate :email_should_be_reasonable

  mount_uploader :image, AvatarUploader

  PER_PAGE = 25

  scope :bots, -> (flag) { where bot: flag.to_i > 0 unless flag.blank? }
  scope :network, -> (network) { where network: network unless network.blank? }

  def self.page_for_administrator(current_page)
    order('network asc, uid asc').page(current_page).per(PER_PAGE)
  end

  def self.with_long_uid(long_uid)
    parts = long_uid.split('-')
    if parts.length > 1
      code = parts.shift
      find_by(network: networks[code], uid: parts.join('-')) if networks.has_key?(code)
    else
      find_by uid: long_uid
    end
  end

  def profile_name
    screen_name || uid
  end

  def name_for_letter
    name || profile_name
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

  def follows?(user)
    user.is_a?(User) && (user.id == self.id)
  end

  def decent?
    dreams_count > 20 && comments_count > 20
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  def text_for_list
    "#{long_uid} (#{profile_name})"
  end

  def flags
    {
        active: allow_login?,
        bot:    bot?
    }
  end

  def should_confirm_email?
    !email.blank? && !email_confirmed?
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
      pattern = /\A[a-z0-9_]{1,18}\z/
      errors.add(:uid, I18n.t('activerecord.errors.models.user.attributes.uid.invalid')) unless uid =~ pattern
    end
  end
end
