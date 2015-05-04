class Grain < ActiveRecord::Base
  include HasUser

  belongs_to :pattern
end
