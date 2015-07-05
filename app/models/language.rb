class Language < ActiveRecord::Base
  validates_presence_of :code, :slug
  validates_uniqueness_of :code
end
