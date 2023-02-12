require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user1) { create(:user) }

  describe 'balance' do
    subject { user1.balance }

    before do
      create(:wallet, user: user1, balance: 100)
    end

    it { is_expected.to eq 100 }
  end

  describe 'withdraw' do
    let(:wallet1) {
      create(:wallet, user: user1, balance: 100)
    }

    before do
      wallet1
      user1.withdraw(70)
    end

    it { expect(user1.balance).to eq 30 }
    it { expect(wallet1.balance).to eq 30 }
  end
end
