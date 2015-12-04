module HasGender
  extend ActiveSupport::Concern

  included do
    enum gender: [:female, :male]

    scope :gender, -> (gender) { where gender: gender unless gender.blank? }
  end

  module ClassMethods
  end

  def numeric_gender
    self.gender.nil? ? nil : self.class.genders[self.gender]
  end
end
