class Code < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user

  enum category: [:confirmation, :recovery]

  validates_presence_of :user_id, :body
  validates_uniqueness_of :body

  after_initialize :generate_body

  PER_PAGE = 25

  scope :recent, -> { order 'id desc' }

  def self.page_for_administrator(current_page)
    recent.page(current_page).per(PER_PAGE)
  end

  # @param [User] user
  def self.recovery_for_user(user)
    parameters = { user: user, category: categories[:recovery], activated: false }
    self.find_by(parameters) || self.create(parameters.merge(payload: user.email))
  end

  # @param [User] user
  def self.confirmation_for_user(user)
    parameters = { user: user, category: categories[:confirmation], activated: false }
    self.find_by(parameters) || self.create(parameters.merge(payload: user.email))
  end

  # Track IP-address and user agent for the recent usage
  #
  # @param [String] ip
  # @param [Agent] agent
  def track!(ip, agent)
    update! ip: ip, agent: agent
  end

  def flags
    {
        active: !activated?
    }
  end

  def text_for_list
    "#{category}: #{user.long_uid}, #{created_at.pubdate}"
  end

  protected

  def generate_body
    if self.body.nil?
      self.body = ''
      Time.now.to_i.to_s(36).reverse.each_char do |char|
        self.body += char + rand(36).to_s(36)
      end
      4.times { self.body += rand(36).to_s(36) }

      self.body = self.body.scan(/.{4}/)[0..3].join('-')
    end
  end
end
