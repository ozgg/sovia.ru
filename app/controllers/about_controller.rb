class AboutController < ApplicationController
  def index
    @title = t('controllers.about.index')
  end

  def features
    @title = t('controllers.about.features')
  end

  def changelog
    @title = t('controllers.about.changelog')
  end

  def terms_of_service
    @title = t('controllers.about.terms_of_service')
  end

  def privacy
    @title = t('controllers.about.privacy')
  end
end
