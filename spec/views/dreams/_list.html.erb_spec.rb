require 'spec_helper'

describe "dreams/_list.html.erb" do
  let(:dreams) { Dream.recent.page(1).per(5) }

  context "when dreams present" do
    it "shows dreams list" do
      dream = create(:dream, title: 'My dream')
      assign(:dreams, dreams)
      render
      expect(rendered).to contain(dream.parsed_title)
    end
  end

  context "when no dreams found" do
    it "shows message 'Снов нет'" do
      assign(:dreams, dreams)
      render
      expect(rendered).to contain(I18n.t('dreams.list.no_dreams'))
    end
  end
end
