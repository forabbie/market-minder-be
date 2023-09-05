def create_users
  User.destroy_all

  1.times do
    user = User.create!(
      email: "admin@stock.com", 
      password: "ChangeMe!",
      account_status: "approved",
      role: "admin",
    )
  end

  p "Created #{User.count} users"
end

create_users