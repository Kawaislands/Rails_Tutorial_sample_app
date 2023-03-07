class UsersController < ApplicationController
  
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
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      # GET "/users/#{@user.id}"
      redirect_to @user
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
      # 更新に成功した場合を扱う。
    else
      render 'edit'
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
