class Code < ActiveRecord::Base
  TYPE_EMAIL_CONFIRMATION = 1
  TYPE_PASSWORD_RECOVERY  = 2

  belongs_to :user
  validates_presence_of :code_type, :body
  validates_inclusion_of :code_type, in: [TYPE_EMAIL_CONFIRMATION, TYPE_PASSWORD_RECOVERY]
  validates_uniqueness_of :body

  after_initialize :generate_body

  def email_confirmation?
    code_type == TYPE_EMAIL_CONFIRMATION
  end

  def self.email_confirmation
    where(code_type: TYPE_EMAIL_CONFIRMATION, activated: false)
  end

  private

  def generate_body
    if self.body.nil?
      self.body = ''
      Time.now.to_i.to_s(36).reverse.each_char do |char|
        self.body += char + rand(36).to_s(36)
      end

      self.body = self.body.scan(/.{4}/)[0..2].join('-')
    end
  end
end
