module Toggleable
  extend ActiveSupport::Concern

  included do
    # @param [String] attribute
    def toggle_parameter(attribute)
      if TOGGLEABLE.include? attribute.to_sym
        toggle! attribute
        { attribute => self[attribute] }
      end
    end
  end
end
