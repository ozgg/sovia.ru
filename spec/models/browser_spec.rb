require 'rails_helper'

RSpec.describe Browser, type: :model do
  describe 'Validation' do
    it 'fails with empty name' do
      browser = build :browser, name: ' '
      expect(browser).not_to be_valid
    end

    it 'fails with non-unique name' do
      browser = create :browser
      expect(build :browser, name: browser.name).not_to be_valid
    end

    it 'passes with valid attributes' do
      expect(Browser.new name: 'Crawler').to be_valid
    end
  end
end
