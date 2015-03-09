class Entry < ActiveRecord::Base
  PRIVACY_NONE  = 0
  PRIVACY_USERS = 1
  PRIVACY_OWNER = 255

  belongs_to :user, counter_cache: true
  has_many :comments, dependent: :destroy
  has_many :entry_tags
  has_many :tags, through: :entry_tags

  validates_presence_of :body, :type
  validates_inclusion_of :privacy, in: [PRIVACY_NONE, PRIVACY_USERS, PRIVACY_OWNER]

  before_save :make_url_title
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

  def self.recent
    order('id desc')
  end

  def self.recent_entries
    Entry::Dream.public_entries.order('id desc').first(2)
  end

  def lucid?
    lucidity > 0
  end

  def shareable?
    privacy == PRIVACY_NONE
  end

  def previous_entry_for(user)
    max_privacy = user.nil? ? PRIVACY_NONE : PRIVACY_USERS
    Entry.where(type: type).where("privacy <= #{max_privacy} and id < #{id}").order('id desc').first
  end

  def next_entry_for(user)
    max_privacy = user.nil? ? PRIVACY_NONE : PRIVACY_USERS
    Entry.where(type: type).where("privacy <= #{max_privacy} and id > #{id}").order('id asc').first
  end

  def owned_by?(user)
    self.user == user
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
    !editor.nil? && ((editor == user) || editor.has_role?(:dreams_manager))
  end

  def parsed_title
    result = title.blank? ? I18n.t('untitled') : title
    result.gsub(/(\S{30})/, '\1 ').gsub('<', '&lt;').gsub('>', '&gt;')
  end

  def author_name
    user.nil? ? I18n.t('anonymous') : user.login
  end

  def publication_date
    created_at.strftime '%d.%m.%Y'
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

    (tags - new_tags).each do |tag_to_delete|
      tag_to_delete.decrement! :entries_count
      UserTag.subtract_tag user, tag_to_delete
    end

    self.tags = new_tags
  end

  def ordered_tags
    self.tags.order('entries_count desc, name asc')
  end

  def preview
    body.gsub(/(\r?\n)+/, "\n").split("\n")[0..1].join("\n")
  end

  def glimpse
    body.gsub(/(\S{20})/, '\1 ').strip.split(/\s+/)[0..50].join(' ')
  end

  def passages_count
    body.strip.gsub(/(\r?\n)+/, "\n").count("\n") + 1
  end

  def datetime
    created_at.strftime '%Y-%m-%dT%H:%M:%S%:z'
  end

  private

  # @abstract, get matching tag by name for this type of entry
  # @param [string] name tag name
  def matching_tag(name)
    raise 'Implement me in children classes'
  end

  def decrement_entries_counter
    tags.each do |tag|
      tag.decrement! :entries_count
    end
  end

  def new_tags_from_string(new_tags_string)
    new_tags = []
    new_tags_string.split(',').each do |new_tag|
      unless new_tag.strip == '' || new_tag.length > 50
        tag = matching_tag(new_tag)
        new_tags << tag unless new_tags.include?(tag)
      end
    end

    new_tags
  end

  def make_url_title
    if title.blank?
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
