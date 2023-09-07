require "securerandom"
class User < ApplicationRecord
  has_many :stocks
  has_many :transactions, through: :stocks
  
  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
            uniqueness: { case_sensitive: false }, 
            length: { maximum: 105 },
            format: { with: VALID_EMAIL_REGEX }

  has_secure_password

  def self.get_authentication_token(signin_params)
    current = User.find_by_email(signin_params[:email])

    if current.present?
      if current && current.authenticate(signin_params[:password])
        current.generate_token
        return current.token
      else
        return "invalid"
      end
    else
      return "not found"
    end
  end

  def verify_password(password, password_confirmation)
    if password == password_confirmation
      self.password = password
    else
      errors.add(:password, "doesn't match")
      false
    end
  end

  def generate_token
    self.token = SecureRandom.base64(32).tr('+/=', 'xyz')
    self.token_expiration = DateTime.now + Rails.application.config.auth_token_expiration
    self.save
  end

  def token_expired?
    self.token_expiration < Time.now
  end

  def admin?
    self.role == "admin"
  end

  def user?
    self.role == "trader"
  end

  def insufficient_balance?(transaction_params)
    self.fund < total_price(transaction_params)
  end

  def deduct_balance!(transaction_params)
    self.fund -= total_price(transaction_params)
    self.save
  end

  def add_balance!(transaction_params)
    self.fund += total_price(transaction_params)
    self.save
  end

  def deposit_cash!(amount)
    self.fund += amount.to_d
    self.save
  end

  private
  def total_price(transaction_params)
    transaction_params[:shares_quantity].to_d * transaction_params[:price].to_d
  end
end
