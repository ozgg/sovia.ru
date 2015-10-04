require 'rails_helper'

RSpec.describe DreamsHelper, type: :helper do
  describe 'parsed_dream_body' do
    it 'splits lines into passages' do
      dream = create :dream, body: "a\nb"
      expected = '<p>a</p><p>b</p>'
      expect(helper.parsed_dream_body(dream, nil)).to eq(expected)
    end

    it 'ignores blank lines' do
      dream = create :dream, body: "\na\r\n\nb\r\n"
      expected = '<p>a</p><p>b</p>'
      expect(helper.parsed_dream_body(dream, nil)).to eq(expected)
    end

    it 'escapes lt and gt' do
      dream = create :dream, body: "<a>"
      expected = '<p>&lt;a&gt;</p>'
      expect(helper.parsed_dream_body(dream, nil)).to eq(expected)
    end

    describe 'dream links' do
      let!(:dream) { create :dream, title: 'Очередной сон' }
      let!(:personal_dream) { create :personal_dream }

      context 'when text given' do
        it 'replaces fragment with link to existing dream with text' do
          new_dream = create :dream, body: "pre [dream #{dream.id}](text) post"
          expected = "<p>pre «#{link_to 'text', dream, title: dream.title_for_view}» post</p>"
          expect(helper.parsed_dream_body(new_dream, nil)).to eq(expected)
        end

        it 'replaces fragment with span and text' do
          new_dream = create :dream, body: "pre [dream #{personal_dream.id}](text) post"
          expected = "<p>pre <span class=\"not-found\">dream #{personal_dream.id}</span> post</p>"
          expect(helper.parsed_dream_body(new_dream, nil)).to eq(expected)
        end
      end

      context 'when text is not given' do
        it 'replaces fragment with dream number in span for non-existing dream' do
          new_dream = create :dream, body: "pre [dream #{personal_dream.id}] post"
          expected  = "<p>pre <span class=\"not-found\">dream #{personal_dream.id}</span> post</p>"
          expect(helper.parsed_dream_body(new_dream, nil)).to eq(expected)
        end
        
        it 'replaces fragment with link to dream and its title for existing dream' do
          new_dream = create :dream, body: "pre [dream #{dream.id}] post"
          expected  = "<p>pre «#{link_to dream.title_for_view, dream, title: dream.title_for_view}» post</p>"
          expect(helper.parsed_dream_body(new_dream, nil)).to eq(expected)
        end
      end
    end

    describe 'names' do
      context 'when user is owner' do
        it 'replaces fragment with acronym and name as title if no text is given' do
          dream = create :owned_dream, body: 'до {вася пупкин} после'
          expected = "<p>до <span class=\"name\" title=\"вася пупкин\">вп</span> после</p>"
          expect(helper.parsed_dream_body(dream, dream.user)).to eq(expected)
        end

        it 'replaces fragment with text and name as title if text is given' do
          dream = create :owned_dream, body: 'до {Вася Пупкин}(Гусь Иваныч) после'
          expected = "<p>до <span class=\"name\" title=\"Вася Пупкин\">Гусь Иваныч</span> после</p>"
          expect(helper.parsed_dream_body(dream, dream.user)).to eq(expected)
        end
      end

      context 'when user is not owner' do
        it 'replaces fragment with acronym when no text is given' do
          dream = create :owned_dream, body: 'до {вася пупкин} после'
          expected = "<p>до <span class=\"name\">вп</span> после</p>"
          expect(helper.parsed_dream_body(dream, nil)).to eq(expected)
        end

        it 'replaces fragment with text if text is given' do
          dream = create :owned_dream, body: 'до {Вася Пупкин}(Гусь Иваныч) после'
          expected = "<p>до <span class=\"name\">Гусь Иваныч</span> после</p>"
          expect(helper.parsed_dream_body(dream, nil)).to eq(expected)
        end
      end
    end
  end
end
