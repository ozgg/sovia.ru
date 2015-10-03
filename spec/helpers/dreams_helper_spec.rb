require 'rails_helper'

RSpec.describe DreamsHelper, type: :helper, wip: true do
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

    describe 'object names' do
      context 'when user is owner' do
        pending
      end

      context 'when user is not owner' do
        pending
      end
    end
  end
end
