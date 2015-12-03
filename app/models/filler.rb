class Filler < ActiveRecord::Base
  include HasGender

  enum category: [:question, :dream]

  validates_presence_of :body

  PER_PAGE = 10

  scope :recent, -> { order 'id desc' }

  def self.page_for_administrator(page)
    recent.page(page).per(PER_PAGE)
  end

  def text_for_list
    "#{id}: #{category}/#{gender}/#{title}"
  end
end
