class My::TagsController < ApplicationController
  before_action :set_tag

  def show
  end

  def edit
  end

  def update
    if @user_tag.update(tag_parameters)
      flash[:notice] = t('tag.updated')
      redirect_to my_tag_path(@user_tag)
    else
      render action: :edit
    end
  end

  private

  def set_tag
    @user_tag = UserTag.find(params[:id])
    raise record_not_found unless @user_tag.user_id == current_user.id
  end

  def tag_parameters
    params.require(:user_tag).permit(:description)
  end
end
