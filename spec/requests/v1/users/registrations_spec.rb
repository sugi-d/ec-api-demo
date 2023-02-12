require 'rails_helper'

RSpec.describe 'V1::Users::Registrations', type: :request do
  describe 'POST /v1/users' do
    context 'valid info' do
      subject {
        post '/v1/users', params: { email: 'user@example.com', password: 'qwerty' }
      }

      it 'returns 200' do
        subject
        assert_response_schema_confirm(200)
      end

      it { expect { subject }.to change(User, :count).by(1) }
      it { expect { subject }.to change(Wallet, :count).by(1) }

      it 'issues 10000 points when sign-up' do
        subject
        user = User.last
        expect(user.wallet.balance).to eq 10000
      end
    end

    context 'invalid info' do
      it 'returns 422' do
        existing_user = create(:user)
        post '/v1/users', params: { email: existing_user.email, password: 'qwerty' }
        assert_response_schema_confirm(422)
      end
    end
  end
end
