class Violation < ActiveRecord::Base
  include HasOwner
  include HasTrace

  belongs_to :user

  validates_presence_of :agent_id, :ip

  enum category: [:dreams_spam, :comments_spam]

  PER_PAGE = 25

  scope :recent, -> { order 'id desc' }

  def self.page_for_administrator(current_page)
    recent.page(current_page).per(PER_PAGE)
  end

  def text_for_list
    "#{created_at.pubdate}, #{category}: #{ip}"
  end
end
