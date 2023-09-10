class UsersSerializer
  attr_reader :users

  def initialize(users)
    @users = users
  end

  def as_json
    {
      "users": @users.map do |user|
      {
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        account_status: user.account_status,
        role: user.role,
        fund: user.fund,
      }
      end
    }
  end
end
