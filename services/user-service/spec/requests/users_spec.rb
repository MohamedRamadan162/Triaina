require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'GET /' do
    let(:pageLimit) { 100 }

    before do
      create_list(:user, 250)
    end

    it 'returns paginated users page 1' do
      get '/', params: { page: 1 }

      expect(response).to have_http_status(:ok)
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse['users'].length).to eq(pageLimit)
      expect(jsonResponse['pagination']['count']).to eq(User.count)
    end

    it 'returns paginated users page 3 with size 50' do
      get '/', params: { page: 3 }

      expect(response).to have_http_status(:ok)
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse['users'].length).to eq(50)
      expect(jsonResponse['pagination']['count']).to eq(User.count)
    end

    it 'returns empty page when out of limit page' do
      get '/', params: { page: 4 }

      expect(response).to have_http_status(:ok)
      jsonResponse = JSON.parse(response.body)
      expect(jsonResponse['users'].length).to eq(0)
      expect(jsonResponse['pagination']['count']).to eq(User.count)
    end
  end

  describe 'GET /:username' do
    let(:user) { create(:user) }

    it 'returns user when found' do
      get "/#{user.username}"

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['user']['username']).to eq(user.username)
    end

    it 'returns not found when user does not exist' do
      get '/nonexistent_user'
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('User not found')
    end
  end

  describe 'POST /' do
    before do
      create_list(:user, 250)
    end

    let(:validParams) do
      {
        username: 'test_user',
        email: 'test@email.com',
        name: 'test user'
      }
    end

    context 'When parameters are valid' do
      it 'return 201 and creates new user in db' do
        expect do
          post '/', params: validParams
        end.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['user']['username']).to eq('test_user')
        expect(json_response['user']['name']).to eq('test user')
        expect(json_response['user']['email']).to eq('test@email.com')
      end
    end

    context 'missing parameters' do
      it 'returns an error when username is missing' do
        post '/', params: { name: 'test user', email: 'test@email.com' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Username is required' })
      end

      it 'returns an error when name is missing' do
        post '/', params: { username: 'test_user', email: 'test@email.com' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Name is required' })
      end

      it 'returns an error when email is missing' do
        post '/', params: { username: 'test_user', name: 'test user' }

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Email is required' })
      end
    end

    context 'duplicate entry' do
      let!(:existingUser) { create(:user, validParams) }

      it 'returns an error when the username is already taken' do
        post '/', params: { username: existingUser.username, name: 'New Name', email: 'new@email.com' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Username has already been taken'] })
      end

      it 'returns an error when the email is already registered' do
        post '/', params: { username: 'new_user', name: 'New Name', email: existingUser.email }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Email has already been taken'] })
      end
    end

    context 'invalid input form' do
      it 'returns an error when email is in an invalid format' do
        post '/', params: { username: 'new_user', name: 'New name', email: 'wrong_email' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Email must be a valid email format'] })
      end

      it 'returns an error when username is in an invalid format' do
        post '/', params: { username: 'new', name: 'New name', email: 'test@email.com' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to eq({ 'errors' => ['Username is too short (minimum is 4 characters)'] })
      end
    end
  end
end
