class UserLanguage < ActiveRecord::Base
  include HasLanguage

  belongs_to :user

  validates_presence_of :user
  validates_uniqueness_of :language, scope: :user

  def self.by_pair(user, language)
    find_by user: user, language: language
  end

  def self.set_link(user_id, language_id, linked)
    link = find_by user_id: user_id, language_id: language_id
    if linked
      create!(user_id: user_id, language_id: language_id) if link.nil?
    else
      link.destroy unless link.nil?
    end
  end

  def i18n_name
    language.i18n_name
  end
end
