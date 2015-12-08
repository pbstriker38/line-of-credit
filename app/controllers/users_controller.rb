class UsersController < ApplicationController
  before_action :require_login, only: [:index]

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.credit_limit = Money.new(100000, 'USD')

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :encrypted_password, :password, :confirmation_token, :remember_token)
    end
end
