require 'spec_helper'

describe DreambookController do
  before(:each) do
    @tag_a = create(:dream_tag, name: 'Акула', description: 'Про акулу')
    @tag_b = create(:dream_tag, name: 'Белка', description: 'Тут про белку')
    @tag_c = create(:dream_tag, name: 'Арка', description: '')
  end

  shared_examples "letter assigner" do
    it "assigns letters to @letters" do
      expect(assigns[:letters]).to include(@tag_a.letter)
      expect(assigns[:letters]).to include(@tag_b.letter)
      expect(assigns[:letters].length).to eq(2)
    end
  end

  context "get index" do
    before(:each) { get :index }

    it "renders dreambook/index" do
      expect(response).to render_template('dreambook/index')
    end

    it_should_behave_like "letter assigner"
  end

  context "get letter" do
    before(:each) { get :letter, letter: @tag_a.letter }

    it "assigns described tags with given letter to @tags" do
      expect(assigns[:dream_tags]).to include(@tag_a)
      expect(assigns[:dream_tags]).not_to include(@tag_b)
      expect(assigns[:dream_tags]).not_to include(@tag_c)
    end

    it "renders dreambook/letter" do
      expect(response).to render_template('dreambook/letter')
    end

    it_should_behave_like "letter assigner"
  end

  context "get word" do
    before(:each) { get :word, letter: @tag_a.letter, word: @tag_a.name }

    it "assigns word to @tag" do
      expect(assigns[:tag]).to eq(@tag_a)
    end

    it "renders dreambook/word" do
      expect(response).to render_template('dreambook/word')
    end

    it_should_behave_like "letter assigner"
  end

  context "get obsolete" do
    it "redirects to letter when only letter given" do
      get :obsolete, letter: @tag_a.letter
      expect(response).to redirect_to(dreambook_letter_path(letter: @tag_a.letter))
    end

    it "redirects to word when word given" do
      get :obsolete, letter: @tag_a.letter, word: @tag_a.name
      expect(response).to redirect_to(dreambook_word_path(letter: @tag_a.letter, word: @tag_a.name))
    end
  end
end