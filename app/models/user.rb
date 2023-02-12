# frozen_string_literal: true

class User < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_one :wallet, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  delegate :balance, to: :wallet

  def withdraw(amount)
    wallet.update(balance: wallet.balance - amount)
  end
end
