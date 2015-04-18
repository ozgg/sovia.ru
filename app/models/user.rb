class User < ActiveRecord::Base
  ROLE_EDITOR    = 1
  ROLE_MODERATOR = 2

  GENDER_FEMALE = 0
  GENDER_MALE   = 1

  has_many :entries, dependent: :destroy
  has_many :codes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :user_tags, dependent: :destroy
  has_many :goals, dependent: :destroy
  has_many :deeds, dependent: :destroy
  has_many :user_roles, dependent: :destroy
  has_many :questions, as: :owner, dependent: :destroy
  has_many :answers, as: :owner, dependent: :destroy
  has_many :posts, dependent: :destroy

  belongs_to :language
  belongs_to :agent

  has_secure_password

  validates_uniqueness_of :login, scope: [:network]
  validates_presence_of :login

  validate :login_should_be_valid
  validate :email_should_be_reasonable
  before_validation :normalize_login, :normalize_email

  mount_uploader :avatar, AvatarUploader

  enum network: [:sovia, :vk]

  def self.genders_for_select
    prefix  = 'activerecord.attributes.user.enums.genders.'
    genders = [[I18n.t('not_selected'), '']]
    genders << [I18n.t(prefix + 'female'), GENDER_FEMALE]
    genders << [I18n.t(prefix + 'male'), GENDER_MALE]
    genders
  end

  def self.random_bot(gender = nil)
    clause = { bot: true }
    if gender
      clause[:gender] = (gender.to_sym === :male) ? GENDER_MALE : GENDER_FEMALE
    end
    offset = rand(self.where(clause).count)
    bot    = self.where(clause).offset(offset).first
    if bot.nil?
      offset = rand(self.where(bot: true).count)
      bot    = self.where(bot: true).offset(offset).first
    end
    bot
  end

  def moderator?
    has_role? :moderator
  end

  def editor?
    has_role? :posts_manager
  end

  def decent?
    entries_count >= 5
  end

  def has_role?(role)
    via_mask  = role.is_a?(Integer) ? roles_mask & role == role : false
    via_roles = (role.is_a?(String) || role.is_a?(Symbol)) ? UserRole.exists_for_user?(role.to_s, self) : false

    via_mask | via_roles
  end

  def can_receive_letters?
    mail_confirmed? && allow_mail? && filled_email?
  end

  def email_confirmation
    Code::Confirmation.code_for_user(self) unless mail_confirmed? || email.blank?
  end

  def password_recovery
    Code::Recovery.code_for_user(self) if sovia? && filled_email?
  end

  def should_use_gravatar?
    use_gravatar? && filled_email? && mail_confirmed?
  end

  def filled_email?
    !email.blank?
  end

  def gravatar_image(size)
    image = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{image}?s=#{size}&d=identicon"
  end

  def roles=(roles)
    roles.each do |role, flag|
      user_role = UserRole.role_for_user(role, self)
      if flag.to_i > 0
        UserRole.create!(user: self, role: role.to_s) if user_role.nil?
      else
        user_role.destroy unless user_role.nil?
      end
    end
  end

  def gender_string
    case gender
      when GENDER_MALE
        I18n.t 'activerecord.attributes.user.enums.genders.male'
      when GENDER_FEMALE
        I18n.t 'activerecord.attributes.user.enums.genders.female'
      else
        I18n.t 'not_selected'
    end
  end

  def language_ids
    ids = []
    ids << language.id unless language.nil?
    UserLanguage.where(user: self).each { |l| ids << l.language.id }
    ids
  end

  def language_ids=(ids)
    ids.each { |index, id| ids[index] = id.to_i }
    Language.all.each do |language|
      linked = ids.has_value? language.id
      UserLanguage.set_link self.id, language.id, linked
    end
  end

  def has_language?(language)
    !UserLanguage.by_pair(self, language).nil?
  end

  def language_names
    names = [language ? language.i18n_name : I18n.t(:not_selected)]
    UserLanguage.where(user: self).each { |l| names << l.i18n_name }
    names.uniq
  end

  def set_from_vk_hash(parameters)
    self.name = "#{parameters.first_name} #{parameters.last_name}"
    case parameters.sex.to_i
      when 1
        self.gender = GENDER_FEMALE
      when 2
        self.gender = GENDER_MALE
      else
        self.gender = nil
    end
    self.avatar_url_big = parameters.photo_400
    self.avatar_url_medium = parameters.photo_200
    self.avatar_url_small = parameters.photo_50
    self.screen_name = parameters.screen_name
  end

  protected

  def normalize_login
    login.downcase! if sovia?
  end

  def normalize_email
    email.downcase! unless email.nil?
  end

  def email_should_be_reasonable
    unless email.nil? || email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
      errors.add(:email, I18n.t('activerecord.errors.models.user.attributes.email.unreasonable'))
    end
  end

  def login_should_be_valid
    if sovia?
      pattern = /\A[a-z0-9_]{1,30}\z/
      errors.add(:login, I18n.t('activerecord.errors.models.user.attributes.login.invalid')) unless login =~ pattern
    end
  end
end
