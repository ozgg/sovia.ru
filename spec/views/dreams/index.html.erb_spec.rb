require 'spec_helper'

describe "dreams/index.html.erb" do
  let(:dreams) { Post.dreams.order('id desc').page(1).per(5) }

  context "when dreams present" do
    it "shows dreams list" do
      dream = create(:dream, title: 'My dream')
      assign(:dreams, dreams)
      render
      expect(rendered).to contain(dream.title)
    end
  end

  context "when no dreams found" do
    it "shows message 'Снов нет'" do
      assign(:dreams, dreams)
      render
      expect(rendered).to contain(I18n.t('dreams.index.no_dreams'))
    end
  end
end
