# frozen_string_literal: true

module Biovision
  module Components
    # Dreambook
    class DreambookComponent < BaseComponent
      LINK_PATTERN = /\[\[(?<body>[^\]]{1,50})\]\](?:\((?<text>[^)]{1,64})\))?/.freeze
      LETTERS = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЫЭЮЯ'
      SLUG = 'dreambook'

      def use_parameters?
        false
      end

      # @param [String] text
      def parse(text)
        text.split("\n").map(&:squish).reject(&:blank?).map { |s| parse_pattern_string(s) }.join
      end

      private

      # Parse string as string from pattern description
      #
      # @param [String] string
      # @return [String]
      def parse_pattern_string(string)
        output = string.gsub('<', '&lt;').gsub('>', '&gt;')
        output = parse_pattern_links output
        "<p>#{output}</p>\n"
      end

      # Parse fragments like [[Pattern]](link text)
      #
      # @param [String] string
      # @return [String]
      def parse_pattern_links(string)
        string.gsub(LINK_PATTERN) do |chunk|
          match = LINK_PATTERN.match(chunk)
          pattern = Pattern[match[:body]]
          pattern_link(pattern, match)
        end
      end

      # @param [Pattern] pattern
      # @param [Hash] match
      def pattern_link(pattern, match)
        if pattern.is_a?(Pattern)
          link_text = match[:text].blank? ? match[:body] : match[:text]
          href = "/dreambook/#{CGI.escape(pattern.name)}"
          %(<a href="#{href}" class="dreambook-pattern">#{link_text}</a>)
        else
          %(<span class="not-found">#{match[:body]}</span>)
        end
      end
    end
  end
end
