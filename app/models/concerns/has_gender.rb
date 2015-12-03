module HasGender
  extend ActiveSupport::Concern

  included do
    enum gender: [:female, :male]

    scope :gender, -> (gender) { where gender: gender unless gender.blank? }
  end

  module ClassMethods
  end
end
