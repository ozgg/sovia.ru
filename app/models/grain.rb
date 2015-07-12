class Grain < ActiveRecord::Base
  belongs_to :language
  belongs_to :user
  belongs_to :pattern
end
