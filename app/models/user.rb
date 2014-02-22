class User < ActiveRecord::Base
  ROLE_ANYONE    = 0
  ROLE_EDITOR    = 1
  ROLE_MODERATOR = 2

  has_many :entries, dependent: :restrict_with_exception
  has_many :codes, dependent: :destroy

  has_secure_password

  validates_uniqueness_of :login
  validates_uniqueness_of :email, allow_nil: true
  validates_format_of :login, with: /\A[a-z0-9_]{1,30}\z/
  validate :email_should_be_reasonable
  before_validation :normalize_login, :normalize_email

  def moderator?
    has_role? ROLE_MODERATOR
  end

  def editor?
    has_role? ROLE_EDITOR
  end

  def has_role?(role)
    roles_mask & role == role
  end

  def email_confirmation
    Code::Confirmation.code_for_user(self) unless mail_confirmed? || email.blank?
  end

  def password_recovery
    Code::Recovery.code_for_user(self) unless email.blank?
  end

  protected

  def normalize_login
    login.downcase!
  end

  def normalize_email
    email.downcase! unless email.nil?
  end

  def email_should_be_reasonable
    unless email.nil? || email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
      errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.unreasonable'))
    end
  end
end
