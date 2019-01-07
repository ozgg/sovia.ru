# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling dreambook
    class DreambookComponent < BaseComponent
      LINK_PATTERN = /\[\[(?<body>[^\]]{1,50})]](?:\((?<text>[^)]{1,64})\))?/.freeze

      # @param [String] text
      def pattern_text(text)
        strings = text.split("\n").map(&:squish).reject(&:blank?)
        strings.map(&method(:parse)).join
      end

      # Parse fragments like [[Pattern]](link text)
      #
      # @param [String] string
      # @return [String]
      def parse_pattern_links(string)
        regex = LINK_PATTERN
        string.gsub(regex) do |chunk|
          match   = regex.match chunk
          pattern = DreambookEntry.match_by_name(match[:body])

          pattern_link(pattern, match[:body], match[:text])
        end
      end

      # @param [DreambookEntry] pattern
      # @param [String] body
      # @param [String] text
      def pattern_link(pattern, body, text)
        if pattern.nil?
          %(<span class="not-found">#{body}</span>)
        else
          link_text = text.blank? ? body : text
          %(<a href="/dreambook/#{CGI.escape(pattern.name)}">#{link_text}</a>)
        end
      end

      private

      # Parse string as string from pattern description
      #
      # @param [String] string
      # @return [String]
      def parse(string)
        output = string.gsub('<', '&lt;').gsub('>', '&gt;')
        output = parse_pattern_links output
        "<p>#{output}</p>\n"
      end
    end
  end
end
