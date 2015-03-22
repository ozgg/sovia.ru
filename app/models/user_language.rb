class UserLanguage < ActiveRecord::Base
  belongs_to :user
  belongs_to :language

  validates_presence_of :user, :language
  validates_uniqueness_of :language, scope: :user
end
