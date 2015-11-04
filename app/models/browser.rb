class Browser < ActiveRecord::Base
  has_many :agents, dependent: :nullify

  validates_presence_of :name
  validates_uniqueness_of :name

  PER_PAGE = 25

  def self.page_for_administrator(current_page)
    order('name asc').page(current_page).per(PER_PAGE)
  end

  def flags
    {
        bot:    bot?,
        mobile: mobile?
    }
  end

  def text_for_list
    name
  end
end
