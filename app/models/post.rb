class Post < ActiveRecord::Base
  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  TYPE_DREAM      = 1
  TYPE_ARTICLE    = 2
  TYPE_POST       = 3
  TYPE_BLOG_ENTRY = 4

  belongs_to :user
  has_many :post_entry_tags
  has_many :entry_tags, through: :post_entry_tags

  validates_presence_of :body
  validates_inclusion_of :privacy, in: [PRIVACY_NONE, PRIVACY_USERS, PRIVACY_OWNER]
  validates_inclusion_of :entry_type, in: [TYPE_DREAM, TYPE_ARTICLE, TYPE_POST, TYPE_BLOG_ENTRY]

  after_create :increment_entries_counter
  after_destroy :decrement_entries_counter

  def self.dreams
    where(entry_type: TYPE_DREAM)
  end

  def self.articles
    where(entry_type: TYPE_ARTICLE)
  end

  def self.privacy_modes
    {
        PRIVACY_NONE  => I18n.t('post.privacy.none'),
        PRIVACY_USERS => I18n.t('post.privacy.users'),
        PRIVACY_OWNER => I18n.t('post.privacy.owner')
    }
  end

  def seen_to?(looker)
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
    tags = self.entry_tags.order('dreams_count desc, name asc')
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

  def parse_body(input)
    '<p>' + CGI::escapeHTML(input.strip).gsub(/(?:\r?\n)+/, '</p><p>') + '</p>'
  end

  def preview
    parse_body body.gsub(/(\r?\n)+/, "\n").split("\n")[0..1].join("\n")
  end

  def dream?
    entry_type === TYPE_DREAM
  end

  def article?
    entry_type === TYPE_ARTICLE
  end

  def passages_count
    body.count "\n"
  end

  private

  def increment_entries_counter
    unless user.nil?
      user.increment! :entries_count
    end
  end

  def decrement_entries_counter
    unless user.nil?
      user.decrement! :entries_count
    end
  end

  def make_url_title
    if title.nil?
      self.url_title = nil
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
