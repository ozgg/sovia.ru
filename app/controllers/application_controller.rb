# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Biovision::Base::PrivilegeMethods

  def default_url_options
    params.key?(:locale) ? { locale: I18n.locale } : {}
  end
end
