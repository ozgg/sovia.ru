module RequiredUniqueName
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name
    validates_uniqueness_of :name

    scope :ordered_by_name, -> { order 'name asc' }
    scope :with_name_like, -> (name) { where 'name ilike ?', "%#{name}%" }
  end
end
