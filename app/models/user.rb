class User < ActiveRecord::Base
  has_secure_password

  validates_uniqueness_of :login, :email
  validates_format_of :login, with: /\A[a-z0-9_]{1,30}\z/
  before_validation :normalize_login, :normalize_email

  protected

  def normalize_login
    login.downcase!
  end

  def normalize_email
    email.downcase! unless email.nil?
  end
end
