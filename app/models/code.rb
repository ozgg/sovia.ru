class Code < ActiveRecord::Base
  TYPE_EMAIL_CONFIRMATION = 1
  TYPE_PASSWORD_RECOVERY  = 2

  belongs_to :user
  validates_presence_of :code_type, :body
  validates_inclusion_of :code_type, in: [TYPE_EMAIL_CONFIRMATION, TYPE_PASSWORD_RECOVERY]
  validates_uniqueness_of :body

end
