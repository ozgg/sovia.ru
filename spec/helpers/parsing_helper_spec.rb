require 'rails_helper'

RSpec.describe ParsingHelper, type: :helper, wip: true do
  describe '#parse_dream_links' do
    let(:dream) { create :dream, title: 'Сон о проверке' }

    context 'when dream is not available' do
      it 'replaces fragment with span' do
        personal_dream = create :personal_dream
        sample = "pre [dream #{personal_dream.id}] post"
        expected = "pre <span class=\"not-found\">dream #{personal_dream.id}</span> post"
        expect(helper.parse_dream_links sample, nil).to eq(expected)
      end
    end

    context 'when text is given' do
      it 'replaces fragment with link containing text' do
        sample = "pre [dream #{dream.id}](text) post"
        expected = "pre «#{link_to 'text', dream, title: dream.title_for_view}» post"
        expect(helper.parse_dream_links sample, nil).to eq(expected)
      end
    end

    context 'when text is not given' do
      it 'replaces fragment with link containing title' do
        sample = "pre [dream #{dream.id}] post"
        expected = "pre «#{link_to dream.title_for_view, dream, title: dream.title_for_view}» post"
        expect(helper.parse_dream_links sample, nil).to eq(expected)
      end
    end
  end

  describe '#parse_post_links' do
    let!(:post) { create :post }

    context 'when post is not available' do
      it 'replaces fragment with span' do
        post_id = Post.last.id + 1
        sample = "pre [post #{post_id}] post"
        expected = "pre <span class=\"not-found\">post #{post_id}</span> post"
        expect(helper.parse_post_links sample).to eq(expected)
      end
    end

    context 'when text is given' do
      it 'replaces fragment with link containing text' do
        sample = "pre [post #{post.id}](text) post"
        expected = "pre «#{link_to 'text', post, title: post.title}» post"
        expect(helper.parse_post_links sample).to eq(expected)
      end
    end

    context 'when text is not given' do
      it 'replaces fragment with link containing title' do
        sample = "pre [post #{post.id}] post"
        expected = "pre «#{link_to post.title, post, title: post.title}» post"
        expect(helper.parse_post_links sample).to eq(expected)
      end
    end
  end

  describe '#parse_pattern_links' do
    context 'when pattern is not available' do
      it 'replaces fragment with span'
    end

    context 'when text is given' do
      it 'replaces fragment with link and text'
    end

    context 'when text is not given' do
      it 'replaces fragment with link and pattern body'
    end
  end

  describe '#parse_names' do
    context 'when text is given' do
      let(:sample) { 'до {Вася Пупкин}(Гусь Иваныч) после' }

      it 'replaces fragment with text and original title for owner' do
        expected = 'до <span class="name" title="Вася Пупкин">Гусь Иваныч</span> после'
        expect(helper.parse_names sample, true).to eq(expected)
      end

      it 'replaces fragment with text for others' do
        expected = 'до <span class="name">Гусь Иваныч</span> после'
        expect(helper.parse_names sample, false).to eq(expected)
      end
    end

    context 'when text is not given' do
      let(:sample) { 'до {Вася Пупкин} после' }

      it 'replaces fragment with acronym and original title for owner' do
        expected = 'до <span class="name" title="Вася Пупкин">ВП</span> после'
        expect(helper.parse_names sample, true).to eq(expected)
      end

      it 'replaces fragment with acronym for others' do
        expected = 'до <span class="name">ВП</span> после'
        expect(helper.parse_names sample, false).to eq(expected)
      end
    end
  end

  describe '#prepare_dream_text' do
    it 'ignores empty lines'
    it 'encloses each line in passage'
    it 'escapes < and >'
    it 'parses links to dreams'
    it 'parses names'
  end

  describe '#prepare_comment_text' do
    it 'ignores empty lines'
    it 'encloses each line in passage'
    it 'escapes < and >'
    it 'parses links to patterns'
    it 'parses links to dreams'
    it 'parses links to posts'
  end

  describe '#prepare_post_text' do
    pending
  end

  describe '#prepare_question_text' do
    it 'ignores empty lines'
    it 'encloses each line in passage'
    it 'escapes < and >'
    it 'parses links to dreams'
    it 'parses links to patterns'
    it 'parses links to posts'
  end
end
