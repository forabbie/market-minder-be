class ApplicationController < ActionController::API  
  def check_authentication
    token = request.headers['Authorization'].gsub('Token ', '')

    if @current_user = User.find_by_token(token)
      if @current_user.token_expired?
        render json: { response: "token expired" }
      end
    else
      render json: { response: "not found" }
    end
  end
  
  def restrict_pendding_accounts
    if @current_user.account_status === "pending"
      render json: { response: "Your account is currently in a pending status." }
    end
  end

  def current_user
    @current_user
  end

  def unauthorized
    render json: { response: "unauthorized" }, status: 422
  end
end
