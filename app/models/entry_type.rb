class EntryType < ActiveRecord::Base
  has_many :entries, dependent: :restrict_with_exception
  has_many :tags, dependent: :restrict_with_exception
  validates_uniqueness_of :name
  validates_format_of :name, with: /\A[a-z]{1,30}\z/

  def self.dream
    find_by(name: 'dream')
  end

  def self.article
    find_by(name: 'article')
  end

  def self.post
    find_by(name: 'post')
  end

  def self.thought
    find_by(name: 'thought')
  end
end
