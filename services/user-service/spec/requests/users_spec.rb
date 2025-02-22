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

    it "returns empty page when out of limit page" do
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
end
