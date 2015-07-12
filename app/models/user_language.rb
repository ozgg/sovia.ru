class UserLanguage < ActiveRecord::Base
  include HasLanguage

  belongs_to :user
  validates_presence_of :user_id
  validates_uniqueness_of :language_id, scope: :user_id
end
