class Api::V1::UsersController < ApplicationController
  before_action :check_authentication
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @users = User.all
    render json: UsersSerializer.new(@users).as_json
  end

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: @users, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: { rowAffected: 1 }
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: @users, status: :no_content
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :role)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
