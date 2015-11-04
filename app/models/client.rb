class Client < ActiveRecord::Base
  validates_presence_of :name, :secret
  validates_uniqueness_of :name

  PER_PAGE = 25

  scope :by_name, -> { order 'name asc' }

  def self.page_for_administrator(current_page)
    by_name.page(current_page).per(PER_PAGE)
  end

  def flags
    {
        active: active?,
    }
  end

  def text_for_list
    name
  end
end
