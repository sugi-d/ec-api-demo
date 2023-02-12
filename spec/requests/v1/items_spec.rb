require 'rails_helper'

RSpec.describe '/v1/items', type: :request do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  let(:valid_attributes) {
    build(:item).attributes
  }

  let(:invalid_attributes) {
    { name: '' }
  }

  let(:valid_headers) {
    { 'Authorization' => access_token }
  }

  let(:access_token) do
    post '/v1/users/sign_in', params: { email: user1.email, password: user1.password }
    response.headers['Authorization']
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      item = create(:item, user: user1)
      get v1_item_url(item), as: :json
      assert_response_schema_confirm(200)
    end

    it 'returns 404 when therere no items' do
      get '/v1/items/0', as: :json
      assert_response_schema_confirm(404)
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      subject do
        post v1_items_url,
             params: { item: valid_attributes }, headers: valid_headers, as: :json
      end

      it 'creates a new Item' do
        expect {
          subject
        }.to change(Item, :count).by(1)
      end

      it 'renders a JSON response with the new item' do
        subject
        assert_response_schema_confirm(201)
      end

      it 'creates a user1s item' do
        subject
        id = JSON.parse(response.body)['id']
        expect(Item.find(id).user).to eq user1
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Item' do
        expect {
          post v1_items_url,
               params: { item: invalid_attributes }, as: :json
        }.not_to change(Item, :count)
      end

      it 'renders a JSON response with errors for the new item' do
        post v1_items_url,
             params: { item: invalid_attributes }, headers: valid_headers, as: :json
        assert_response_schema_confirm(422)
      end
    end

    context 'without authorization' do
      it 'rejects the request' do
        post v1_items_url,
             params: { item: valid_attributes }, as: :json
        assert_response_schema_confirm(401)
      end
    end
  end

  describe 'PATCH /update' do
    let(:item) { create(:item, user: user1) }

    let(:new_attributes) {
      { price: 19800 }
    }

    context 'with valid parameters' do
      it 'updates the requested item' do
        patch v1_item_url(item),
              params: { item: new_attributes }, headers: valid_headers, as: :json
        item.reload
        expect(item.price).to eq new_attributes[:price]
      end

      it 'renders a JSON response with the item' do
        patch v1_item_url(item),
              params: { item: new_attributes }, headers: valid_headers, as: :json
        assert_response_schema_confirm(200)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the item' do
        patch v1_item_url(item),
              params: { item: invalid_attributes }, headers: valid_headers, as: :json
        assert_response_schema_confirm(422)
      end
    end

    context 'attempt to update other users item' do
      it 'rejects the request' do
        item = create(:item, user: user2)
        patch v1_item_url(item),
              params: { item: new_attributes }, headers: valid_headers, as: :json
        assert_response_schema_confirm(401)
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:item) { create(:item, user: user1) }

    context 'valid user' do
      it 'destroys the requested item' do
        expect {
          delete v1_item_url(item), headers: valid_headers, as: :json
        }.to change(Item, :count).by(-1)
      end

      it 'returns 204' do
        delete v1_item_url(item), headers: valid_headers, as: :json
        assert_response_schema_confirm(204)
      end
    end

    context 'invalid user' do
      it 'rejects the request' do
        item = create(:item, user: user2)
        delete v1_item_url(item), headers: valid_headers, as: :json
        assert_response_schema_confirm(401)
      end
    end

    context 'unauthorized guest' do
      it 'rejects the request' do
        delete v1_item_url(item), as: :json
        assert_response_schema_confirm(401)
      end
    end
  end
end
