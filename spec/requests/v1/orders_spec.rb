require 'rails_helper'

RSpec.describe '/v1/orders', type: :request do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:user2) { create(:user) }
  let(:item1) { create(:item, user: seller, price: 100) }

  # This should return the minimal set of attributes required to create a valid
  # Order. As you add validations to Order, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { item_id: item1.id }
  }

  let(:invalid_attributes) {
    { item_id: nil }
  }

  # This should return the minimal set of values that should be in the headers
  # in order to pass any filters (e.g. authentication) defined in
  # OrdersController, or in your router and rack
  # middleware. Be sure to keep this updated too.
  let(:valid_headers) {
    { 'Authorization' => access_token }
  }

  let(:access_token) do
    post '/v1/users/sign_in', params: { email: buyer.email, password: buyer.password }
    response.headers['Authorization']
  end

  describe 'GET /show' do
    let(:order) { create(:order, item: item1, user: buyer) }

    it 'renders a successful response' do
      get v1_order_url(order), headers: valid_headers, as: :json
      assert_response_schema_confirm(200)
    end

    it 'wont render to unauthorized guest' do
      get v1_order_url(order), as: :json
      assert_response_schema_confirm(401)
    end

    it 'wont render to non-buyer user' do
      order = create(:order, item: item1, user: seller)
      get v1_order_url(order), headers: valid_headers, as: :json
      assert_response_schema_confirm(401)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      before do
        create(:wallet, user: buyer, balance: 100)
      end

      it 'creates a new Order' do
        expect {
          post v1_orders_url,
               params: valid_attributes, headers: valid_headers, as: :json
        }.to change(Order, :count).by(1)
      end

      it 'renders a JSON response with the new order' do
        post v1_orders_url,
             params: valid_attributes, headers: valid_headers, as: :json
        assert_response_schema_confirm(201)
      end
    end

    context 'with invalid parameters' do
      before do
        create(:wallet, user: buyer, balance: 100)
      end

      it 'does not create a new Order' do
        expect {
          post v1_orders_url,
               params: invalid_attributes,
               headers: valid_headers,
               as: :json
        }.not_to change(Order, :count)
      end

      it 'returns 404' do
        post v1_orders_url,
             params: invalid_attributes, headers: valid_headers, as: :json
        assert_response_schema_confirm(404)
      end
    end

    context 'sold out items' do
      before do
        create(:wallet, user: buyer, balance: 100)
        create(:order, item: item1, user: user2)
      end

      it 'returns 422' do
        post v1_orders_url,
             params: valid_attributes, headers: valid_headers, as: :json
        assert_response_schema_confirm(422)
      end
    end

    context 'not enough balance' do
      before do
        create(:wallet, user: buyer, balance: 99)
      end

      it 'returns 422' do
        post v1_orders_url,
             params: valid_attributes, headers: valid_headers, as: :json
        assert_response_schema_confirm(422)
      end
    end
  end
end
