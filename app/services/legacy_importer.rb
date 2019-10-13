# frozen_string_literal: true

# Legacy importer for structure for version 5
class LegacyImporter
  ALLOWED_USER = %w[
      allow_login bot created_at email email_confirmed ip last_seen
      password_digest screen_name slug updated_at
  ].freeze

  # @param [String] media_dir
  def initialize(media_dir = nil)
    @media_dir = media_dir
  end

  # @param [Integer] id
  # @param [Hash] data
  def import_user(id, data)
    no_dreams = data['dreams_count'].zero?
    no_comments = data['comments_count'].zero?
    no_posts = data['posts_count'].zero?
    return if no_dreams && no_comments && no_posts

    @user = User.find_or_initialize_by(id: id)
    @data = data
    @user.consent = true
    data['network'] == 'native' ? import_native_user : import_foreign_user
  end

  private

  # @param [String] prefix
  def import_native_user(prefix = nil)
    @user.assign_attributes(@data.select { |a| ALLOWED_USER.include?(a) })
    unless prefix.nil?
      @user.slug = "#{prefix}-#{@data['slug']}"
      @user.screen_name = "#{prefix}:#{@data['screen_name']}"
    end
    check_email
    add_profile_data
    add_user_image
    @user.agent = Agent[@data['agent']] if @data.key?('agent')
    @user.save!
  end

  def import_foreign_user
    foreign_site = ForeignSite.find_by(slug: @data['network'])
    user = foreign_user(foreign_site)
    @user.foreign_slug = true
    import_native_user(foreign_site.slug)
    user.user = @user
    user.save!
  end

  def add_user_image
    return if !@data.key?('image') || @data['image'].blank?

    image_file = "#{@media_dir}/#{@user.id}/#{@data['image']}"
    @user.image = Pathname.new(image_file).open if File.exist?(image_file)
  end

  def add_profile_data
    %w[name surname].each do |field|
      @user.data['profile'][field] = @data[field] unless @data[field].blank?
    end
  end

  # @param [ForeignSite] site
  def foreign_user(site)
    allowed = %w[slug name email ip created_at updated_at]
    user = ForeignUser.new(foreign_site: site)
    user.assign_attributes(@data.select { |a| allowed.include?(a) })
    user.agent = Agent[@data['agent']] if @data.key?('agent')
    data = {
      uid: user.slug,
      info: { name: user.name, email: user.email }
    }
    user.data = JSON.generate(data)
    user
  end

  def check_email
    existing = User.find_by(email: @user.email)

    return if existing.nil?

    @user.notice = @user.email
    @user.email = nil
  end
end
