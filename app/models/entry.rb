class Entry < ActiveRecord::Base
  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  belongs_to :user
  has_many :entry_tags
  has_many :tags, through: :entry_tags

  validates_presence_of :body, :type
  validates_inclusion_of :privacy, in: [PRIVACY_NONE, PRIVACY_USERS, PRIVACY_OWNER]

  after_create :increment_entries_counter, :make_url_title
  before_destroy :decrement_entries_counter

  def self.privacy_modes
    {
        PRIVACY_NONE  => I18n.t('activerecord.properties.entry.privacy.none'),
        PRIVACY_USERS => I18n.t('activerecord.properties.entry.privacy.users'),
        PRIVACY_OWNER => I18n.t('activerecord.properties.entry.privacy.owner')
    }
  end

  def self.public_entries
    where(privacy: PRIVACY_NONE)
  end

  def self.recent_entries
    posts = Entry::Dream.public_entries.last(2)
    posts += Entry::Article.last(1)
    posts += Entry::Post.public_entries.last(1)
    posts += Entry::Thought.public_entries.last(1)

    posts.sort { |a, b| b.created_at <=> a.created_at }
  end

  def visible_to?(looker)
    case privacy
      when PRIVACY_NONE
        true
      when PRIVACY_USERS
        !looker.nil?
      else
        user == looker
    end
  end

  def editable_by?(editor)
    !editor.nil? && ((editor == user) || editor.moderator?)
  end

  def parsed_title
    title || I18n.t('untitled')
  end

  def parsed_body
    parse_body body
  end

  def tags_string
    tags = ordered_tags
    if tags.any?
      buffer = []
      tags.each do |tag|
        buffer << tag.name
      end
      buffer.join(', ')
    else
      ''
    end
  end

  def tags_string=(new_tags_string)
    new_tags = new_tags_from_string new_tags_string

    (tags - new_tags).each { |tag_to_delete| tag_to_delete.decrement! :entries_count }

    self.tags = new_tags
  end

  def ordered_tags
    self.tags.order('entries_count desc, name asc')
  end

  def parse_body(input)
    '<p>' + CGI::escapeHTML(input.strip).gsub(/(?:\r?\n)+/, '</p><p>') + '</p>'
  end

  def preview
    parse_body body.gsub(/(\r?\n)+/, "\n").split("\n")[0..1].join("\n")
  end

  def passages_count
    body.gsub(/(\r?\n)+/, "\n").count "\n"
  end

  private

  def increment_entries_counter
    user.increment! :entries_count unless user.nil?
  end

  def decrement_entries_counter
    user.decrement! :entries_count unless user.nil?
    tags.each do |tag|
      tag.decrement! :entries_count
    end
  end

  def new_tags_from_string(new_tags_string)
    new_tags = []
    new_tags_string.split(',').each do |new_tag|
      unless new_tag.strip == ''
        tag = Tag.match_or_create_by_name(new_tag, entry_type)
        new_tags << tag unless new_tags.include?(tag)
      end
    end

    new_tags
  end

  def make_url_title
    if title.nil?
      self.url_title = 'bez-nazvaniya'
    else
      self.url_title = title.mb_chars.downcase.to_s
      {
          'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', 'е' => 'e', 'ё' => 'yo', 'ж' => 'zh', 'з' => 'z',
          'и' => 'i', 'й' => 'j', 'к' => 'k', 'л' => 'l', 'м' => 'm', 'н' => 'n', 'о' => 'o', 'п' => 'p', 'р' => 'r',
          'с' => 's', 'т' => 't', 'у' => 'u', 'ф' => 'f', 'х' => 'kh', 'ц' => 'c', 'ч' => 'ch', 'ш' => 'sh',
          'щ' => 'shh', 'ъ' => '', 'ы' => 'y', 'ь' => '', 'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
      }.each { |k, v| self.url_title.gsub!(k, v) }
      self.url_title.downcase!
      self.url_title.gsub!(/[^-a-z0-9_]/, '-')
      self.url_title.gsub!(/^[-_]*([-a-z0-9_]*[a-z0-9]+)[-_]*$/, '\1')
      self.url_title.gsub!(/--+/, '-')
    end
  end
end
