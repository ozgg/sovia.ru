class Code < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :body
  validates_uniqueness_of :body

  after_initialize :generate_body

  def self.code_for_user(user)
    find_by(user: user, activated: false) || self.create!(user: user)
  end

  protected

  def set_email_as_payload
    unless user.email.blank? || !payload.blank?
      self.payload = user.email
    end
  end

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
