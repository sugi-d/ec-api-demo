require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:user2) { create(:user) }
  let(:item) { create(:item, user: seller, price: 100) }

  context 'purchase' do
    describe 'buyer has enough balance' do
      subject { item.purchase(buyer) }

      before do
        create(:wallet, user: buyer, balance: 150)
      end

      it { is_expected.to be true }

      it 'creates order' do
        subject
        expect(item.order).to be_present
        expect(item.order.user).to eq buyer
        expect(buyer.balance).to eq 50
      end
    end

    describe 'buyer doesnt have enough balance' do
      subject { item.purchase(buyer) }

      before do
        create(:wallet, user: buyer, balance: 99)
      end

      it { is_expected.to be false }

      it 'creates order' do
        subject
        expect(item.order).to be_blank
        expect(buyer.balance).to eq 99
      end
    end

    describe 'sold out item' do
      subject { item.purchase(buyer) }

      before do
        create(:wallet, user: buyer, balance: 150)
        create(:order, user: user2, item:)
      end

      it { is_expected.to be false }

      it 'cant be sold twice' do
        subject
        expect(item.order.user).not_to eq buyer
        expect(buyer.balance).to eq 150
      end
    end

    describe 'own item' do
      subject { item.purchase(seller) }

      before do
        create(:wallet, user: seller, balance: 150)
      end

      it { is_expected.to be false }

      it 'cant be sold to seller' do
        subject
        expect(item.order).to be_blank
        expect(seller.balance).to eq 150
      end
    end
  end
end
