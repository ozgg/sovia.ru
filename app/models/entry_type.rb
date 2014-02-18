class EntryType < ActiveRecord::Base
  has_many :entries, dependent: :restrict_with_exception
  has_many :tags, dependent: :restrict_with_exception
  validates_uniqueness_of :name
  validates_format_of :name, with: /\A[a-z]{1,30}\z/
end
