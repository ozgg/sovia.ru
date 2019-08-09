# frozen_string_literal: true

module Biovision
  module Components
    # Component for handling dreams
    class DreamsComponent < BaseComponent
      SLUG = 'dreams'

      LINK_PATTERN = /\[dream (?<id>\d{1,7})\](?:\((?<text>[^)]{1,64})\))?/.freeze
      NAME_PATTERN = /{(?<name>[^}]{1,30})}(?:\((?<text>[^)]{1,30})\))?/.freeze

      # @param [Dream] dream
      def parsed_dream(dream)
        owner   = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?)
        strings.map { |s| parse(s, owner) }.join
      end

      # @param [Dream] dream
      def dream_preview(dream)
        owner   = dream.user
        strings = dream.body.split("\n").map(&:squish).reject(&:blank?).first(2)
        strings.map { |s| parse(s, owner) }.join
      end

      # @param [Dream] dream
      # @param [String] text
      # @param [Integer] fallback_id
      def dream_link(dream, text, fallback_id)
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
      # @return [String]
      def parse_links(string)
        pattern = LINK_PATTERN
        string.gsub(pattern) do |chunk|
          match = pattern.match(chunk)
          dream = Dream.visible.find_by(id: match[:id])
          dream_link(dream, match[:text], match[:id])
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
      def parse(string, owner)
        output = string.gsub('<', '&lt;').gsub('>', '&gt;')
        output = parse_links(output)
        output = parse_names(output, user == owner) unless owner.nil?
        "<p>#{output}</p>\n"
      end

      def can_add_sleep_place?
        return false if user.nil?

        SleepPlace.owned_by(user).count < settings['place_limit']
      end
    end
  end
end
