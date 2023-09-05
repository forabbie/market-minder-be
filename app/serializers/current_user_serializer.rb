class CurrentUserSerializer
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def as_json
    {
      "current_user": {
        id: @current_user.id,
        first_name: @current_user.first_name,
        last_name: @current_user.last_name,
        email: @current_user.email,
        account_status: @current_user.account_status,
        role: @current_user.role,
        token_expiration: @current_user.token_expiration,
        cash_balance: @current_user.cash_balance
      }
    }
  end
end
