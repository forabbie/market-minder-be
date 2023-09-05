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
        email: user.email,
        # password_digest: user.password_digest,
        account_status: user.account_status,
        role: user.role,
      }
      end
    }
  end
end
