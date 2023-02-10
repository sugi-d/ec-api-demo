require 'rails_helper'

RSpec.describe 'V1::Users::Registrations', type: :request do
  describe 'POST /v1/users' do
    it 'returns 200' do
      post '/v1/users', params: { email: 'user@example.com', password: 'qwerty' }
      assert_response_schema_confirm(200)
    end

    it 'returns 422' do
      existing_user = create(:user)
      post '/v1/users', params: { email: existing_user.email, password: 'qwerty' }
      assert_response_schema_confirm(422)
    end
  end
end
