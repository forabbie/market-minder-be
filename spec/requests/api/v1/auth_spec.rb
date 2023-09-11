require 'rails_helper'

RSpec.describe "Api::V1::Auths", type: :request do
  let(:user) { create :user }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  describe 'POST /signup' do
    it 'creates a new user and returns a token' do
      post '/api/v1/auth/signup', params: {
        user: {
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }

      expect(response).to have_http_status(200)
      expect(json_response).to have_key('token')
    end

    it 'returns an error if password confirmation does not match' do
      post '/api/v1/auth/signup', params: {
       user: {
        email: 'test@example.com',
        password: 'password',
        password_confirmation: 'wrong_password'
       }
      }
      expect(response).to have_http_status(422)
      expect(json_response).to include({"password"=>"doesn't match"})
    end
  end


  describe 'GET /current' do
    it 'returns a success response if the token is valid' do
      user = FactoryBot.create(:user)
      user.generate_token
      user.save

      get '/api/v1/auth/current', headers: { 'Authorization' => "Token #{user.token}" }

      expect(response).to have_http_status(200)
    end

    it 'returns an error response if the token is expired' do
      user = FactoryBot.create(:user, token_expiration: 1.week.ago)
      user.generate_token
      user.save
      user.update(token_expiration: 1.week.ago)
      user.save

      get '/api/v1/auth/current', headers: { 'Authorization' => "Token #{user.token}" }

      expect(response).to have_http_status(401)
      expect(json_response).to include('response' => 'token expired')
    end

    it 'returns an error response if the token is not found' do
      get '/api/v1/auth/current', headers: { 'Authorization' => 'Token invalid_token' }

      expect(response).to have_http_status(401)
      expect(json_response).to include('response' => 'not found')
    end
  end

  def json_response
    JSON.parse(response.body)
  end
end
