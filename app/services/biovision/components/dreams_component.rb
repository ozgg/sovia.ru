# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling dreams
    class DreamsComponent < BaseComponent
      LINK_PATTERN = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/.freeze
      NAME_PATTERN = /{(?<name>[^}]{1,30})}(?:\((?<text>[^)]{1,30})\))?/.freeze

      # @param [Dream] dream
      # @param [User] user
      def parsed_dream(dream, user)
        owner   = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?)
        strings.map { |s| parse(s, owner, user) }.join
      end

      def dream_preview(dream, user)
        owner   = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?).first(2)
        strings.map { |s| parse(s, owner, user) }.join
      end

      # @param [Dream] dream
      # @param [User] user
      # @param [String] text
      # @param [Integer] fallback_id
      def dream_link(dream, user, text, fallback_id)
        if dream&.visible_to?(user)
          title     = dream.title || I18n.t(:untitled)
          link_text = text.blank? ? title : text
          href      = "/dreams/#{dream.id}"
          %(<cite><a href="#{href}" title="#{title}">#{link_text}</a></cite>)
        else
          %(<span class="not-found">[dream #{fallback_id}]</span>)
        end
      end

      # Parse fragments like [dream 123](link text)
      #
      # @param [String] string
      # @param [User] user
      # @return [String]
      def parse_links(string, user)
        pattern = LINK_PATTERN
        string.gsub(pattern) do |chunk|
          match = pattern.match(chunk)
          dream = Dream.visible.find_by(id: match[:id])
          dream_link(dream, user, match[:text], match[:id])
        end
      end

      # Parse fragments like {Real Name}(text)
      #
      # @param [String] string
      # @param [TrueClass|FalseClass] show_names
      # @return [String]
      def parse_names(string, show_names)
        pattern = NAME_PATTERN
        string.gsub(pattern) do |chunk|
          match = pattern.match chunk
          name  = match[:text] || match[:name].split(/[\s-]+/).map(&:first).join

          title = show_names ? match[:name] : ''
          %(<span class="name-in-dream" title="#{title}">#{name}</span>)
        end
      end

      # @param [String] string
      # @param [User] owner
      # @param [User] user
      def parse(string, owner, user)
        output = string.gsub('<', '&lt;').gsub('>', '&gt;')
        output = parse_links(output, user)
        output = parse_names(output, user == owner) unless owner.nil?
        "<p>#{output}</p>\n"
      end
    end
  end
end
