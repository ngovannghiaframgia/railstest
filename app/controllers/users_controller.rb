class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy following followers)
  before_action :admin_user, only: :destroy
  before_action :load_user, only: %i(show edit update destroy correct_user)

  def index
    @users = User.where(activated: true).page(params[:page]).per Settings.user.record_page
  end

  def show
    @microposts = @user.microposts.page(params[:page]).per Settings.user.record_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".please_check_your_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update user_params
      flash[:success] = t ".profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t ".user_deleted"
    else
      flash[:error] = t ".deleted_failed"
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render "show_follow"
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,:password_confirmation
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user.current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = t "not_found"
    redirect_to login_path
  end
end
