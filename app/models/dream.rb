class Dream < ActiveRecord::Base
  include HasLanguage
  include HasUser

  belongs_to :agent
end
