class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    # GET /users/:id
    @user = User.find(params[:id])
  end

  def new
    # GET /users/new
    @user = User.new
  end
  
  def create
    # POST /users + (params)
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
      # GET "/users/#{@user.id}"
      # redirect_to @user
      # redirect_to user_url(@user)
      # redirect_to user_url(@user.id)
      # redirect_to user_url(1)
      #             => /users/1
    else
      render 'new'
    end
  end
  
  # /users/:id/edit
  def edit
    @user = User.find(params[:id])
    # => app/views/users/edit.html.erb
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
       flash[:success] = "Profile updated"
       redirect_to @user
    else
      render 'edit'
    end
  end
  
  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
  
      # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
