class UsersController < ApplicationController


  before_filter :authenticate_user!
  before_filter :super_admin, only: [:edit, :update]
  before_filter :admin, only: [:new, :create, :index, :destroy]
  before_filter :correct_user, only: :show


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Success.'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(admin_user_params)
      flash[:success] = 'User updated'
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
    def user_params
      if params[:user][:password].blank?
        params.require(:user).permit(:first_name, :last_name, :email)
      else
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
      end
    end

    def admin_user_params
      params.require(:user).permit(:first_name, :last_name, :email, :role)
    end

end