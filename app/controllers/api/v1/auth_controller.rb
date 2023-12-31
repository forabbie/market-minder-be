class Api::V1::AuthController < ApplicationController
  before_action :check_authentication, only: [:current, :signout]
  
  def signup
    @user = User.new(signup_params)
    if @user.verify_password(signup_params[:password], signup_params[:password_confirmation])
      @user.generate_token
      if @user.save
        AuthMailer.pending_email(@user).deliver_later
        render json: { token: @user.token  }
      else
        render json: @user.errors, status: 422
      end
    else
      render json: { password: "doesn't match" }, status: 422
    end
  end

  def signin
    if @user_token = User.get_authentication_token(params[:user])
      render json: { token: @user_token }
    else
      render json: "There was something wrong with your login details", status: 404
    end
  end

  def current
    render json: @current_user, except: [:password_digest, :token]
  end

  def signout
    if @current_user.update(token: nil)
      render json: { signout: true }
    else
      render json: { error: "not found"}
    end
  end

  private
  def signup_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def signin_params
    params.require(:user).permit(:email, :password)
  end
end
