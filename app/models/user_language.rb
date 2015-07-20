class UserLanguage < ActiveRecord::Base
  include HasLanguage

  belongs_to :user
  validates_presence_of :user_id
  validates_uniqueness_of :language_id, scope: :user_id

  def self.user_speaks_language?(user, language)
    self.where(user: user, language: language).count == 1
  end
end
