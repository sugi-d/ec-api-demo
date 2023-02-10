require 'rails_helper'

RSpec.describe 'V1::Users::Sessions', type: :request do
  describe 'POST /v1/users/sign_in' do
    let(:user) { create(:user) }

    describe 'valid credential' do
      before { post '/v1/users/sign_in', params: { email: user.email, password: user.password } }

      it 'returns 200' do
        assert_response_schema_confirm(200)
      end

      it 'returns bearer token' do
        expect(response.headers.keys).to include('Authorization')
        expect(response.headers['Authorization']).to include('Bearer')
      end
    end

    describe 'invalid credential' do
      before { post '/v1/users/sign_in', params: { email: user.email, password: '12345' } }

      it 'returns 401' do
        assert_response_schema_confirm(401)
      end

      it 'wont returns bearer token' do
        expect(response.headers.keys).not_to include('Authorization')
      end
    end

    describe 'non existing credential' do
      before { post '/v1/users/sign_in', params: { email: 'nonexisting@example.com', password: '12345' } }

      it 'returns 401' do
        assert_response_schema_confirm(401)
      end

      it 'wont returns bearer token' do
        expect(response.headers.keys).not_to include('Authorization')
      end
    end
  end
end
