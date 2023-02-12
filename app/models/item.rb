class Item < ApplicationRecord
  belongs_to :user
  has_one :order, dependent: :destroy
  validates :name, presence: true
  validates :price, presence: true

  def purchase(buyer)
    if buyer != user && self.order.blank? && buyer.balance >= price
      Order.new(user: buyer, item: self).save
      buyer.withdraw(price)
      true
    else
      false
    end
  end
end
