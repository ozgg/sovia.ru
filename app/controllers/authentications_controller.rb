class AuthenticationsController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: [:destroy]

  # get /login
  def new
  end

  # post /login
  def create
    user = User.find_by network: 'native', uid: params[:login].to_s.downcase
    if user.is_a?(User) && user.authenticate(params[:password].to_s) && user.allow_login?
      create_token_for_user user, tracking_for_entity
      redirect_to root_path
    else
      flash.now[:notice] = t(:could_not_log_in)
      render :new
    end
  end

  # delete /logout
  def destroy
    deactivate_token if current_user
    redirect_to root_path
  end

  def external
    render plain: params[:provider]
  end

  def callback
    @data = request.env['omniauth.auth']
    log_data
    message = "set_#{params[:provider]}_account"
    send message if respond_to? message, true

    redirect_to root_path
  end

  private

  def deactivate_token
    token = Token.find_by token: cookies['token'].split(':').last
    token.update active: false
    cookies['token'] = nil
  end

  def log_data
    file = "#{Rails.root}/log/oauth.json"
    File.open(file, 'a') { |f| f.puts @data.to_json }
  end

  def set_twitter_account
    account = User.find_by(network: User.networks[:twitter], uid: @data[:uid]) || create_twitter_account
    create_token_for_user account, tracking_for_entity
  end

  def set_facebook_account
    account = User.find_by(network: User.networks[:fb], uid: @data[:uid])
    if account.is_a? User
      new_data = Hash.new
      if account.image.blank?
        new_data[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?
      end
      account.update(new_data) unless new_data.blank?
    else
      account = create_facebook_account
    end

    create_token_for_user account, tracking_for_entity
  end

  def set_vkontakte_account
    account = User.find_by(network: User.networks[:vk], uid: @data[:uid])
    if account.is_a? User
      new_data = Hash.new
      if account.email.blank?
        new_data.merge(email: @data[:info][:email], email_confirmed: true, allow_mail: true)
      end
      if account.image.blank?
        new_data[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?
      end
      account.update(new_data) unless new_data.blank?
    else
      account = create_vk_account
    end
    create_token_for_user account, tracking_for_entity
  end

  def set_mail_ru_account
    account = User.find_by(network: User.networks[:mail_ru], uid: @data[:uid]) || create_mail_ru_account
    create_token_for_user account, tracking_for_entity
  end

  def create_twitter_account
    parameters = {
        network: User.networks[:twitter],
        screen_name: @data[:info][:nickname]
    }
    parameters[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?

    User.create! parameters.merge(shared_parameters)
  end

  def create_facebook_account
    parameters = {
        network: User.networks[:fb],
        screen_name: @data[:info][:name],
    }
    parameters[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?

    User.create! parameters.merge(shared_parameters)
  end

  def create_vk_account
    if @data[:info][:nickname].blank? || (@data[:info][:nickname] == "id#{@data[:uid]}")
      screen_name = @data[:info][:name]
    else
      screen_name = @data[:info][:nickname]
    end
    parameters = {
        network: User.networks[:vk],
        screen_name: screen_name
    }
    parameters[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?

    User.create! parameters.merge(shared_parameters)
  end

  def create_mail_ru_account
    parameters = {
        network: User.networks[:mail_ru],
        screen_name: @data[:info][:nickname]
    }
    parameters[:remote_image_url] = @data[:info][:image] unless @data[:info][:image].blank?

    User.create! parameters.merge(shared_parameters)
  end

  def shared_parameters
    {
        uid: @data[:uid],
        email: @data[:info][:email],
        name: @data[:info][:name],
        email_confirmed: true,
        allow_mail: true,
        password_digest: BCrypt::Engine.hash_secret(Time.now.to_s(26), BCrypt::Engine.generate_salt),
    }.merge(tracking_for_entity)
  end
end
