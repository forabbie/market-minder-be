class Api::V1::UsersController < ApplicationController
  before_action :check_authentication
  before_action :restrict_pendding_accounts, only:[:deposit_cash]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
    if params[:status].present?
      case params[:status]
      when 'pending'
        @users = @users.where(account_status: 'pending')
      when 'approved'
        @users = @users.where(account_status: 'approved')
      else
        render json: { error: "Invalid 'status' parameter" }, status: :unprocessable_entity
        return
      end
    end
    render json: UsersSerializer.new(@users).as_json
  end


  def deposit_cash
    @user = User.find(current_user.id)
    @fund = @user.fund
    if @user.nil?
      render json: { error: "User not found" }, status: :not_found
    else
      if @user.deposit_cash!(params[:fund])
        render json: { rowAffected: 1 }
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end
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
      if @user.account_status == "approved"
        AuthMailer.approval_email(@user).deliver_later
      end
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
    params.require(:user).permit(:first_name, :last_name, :email, :password, :role, :account_status)
  end

  def status_params
    params.permit(:status)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
