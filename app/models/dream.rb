class Dream < ActiveRecord::Base
  include HasLanguage
  include HasUser
  include HasPrivacy

  belongs_to :agent
  belongs_to :place
end
