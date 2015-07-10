class User < ActiveRecord::Base
  include HasLanguage
  include HasTrace

  has_secure_password

  enum gender: [:female, :male]
  enum network: [:native, :vk, :twitter, :fb, :mail_ru]

  before_validation :normalize_email, :normalize_screen_name

  protected

  def normalize_screen_name
    self.uid = screen_name.downcase if native?
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
