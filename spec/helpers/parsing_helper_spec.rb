require 'rails_helper'

RSpec.describe ParsingHelper, type: :helper, wip: true do
  describe '#parse_dream_links' do
    context 'when dream is not available' do
      it 'replaces fragment with span'
    end

    context 'when text is given' do
      it 'replaces fragment with link containing text'
    end

    context 'when text is not given' do
      it 'replaces fragment with link containing title'
    end
  end

  describe '#parse_post_links' do
    context 'when post is not available' do
      it 'replaces fragment with span'
    end

    context 'when text is given' do
      it 'replaces fragment with link containing text'
    end

    context 'when text is not given' do
      it 'replaces fragment with link containing title'
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
      it 'replaces fragment with text and original title for owner'
      it 'replaces fragment with text for others'
    end

    context 'when text is not given' do
      it 'replaces fragment with acronym and original title for owner'
      it 'replaces fragment with acronym for others'
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
