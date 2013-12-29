class User < ActiveRecord::Base
  has_many :articles

  has_secure_password

  validates_uniqueness_of :login
  validates_uniqueness_of :email, allow_nil: true
  validates_format_of :login, with: /\A[a-z0-9_]{1,30}\z/
  validate :email_should_be_reasonable
  before_validation :normalize_login, :normalize_email

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
