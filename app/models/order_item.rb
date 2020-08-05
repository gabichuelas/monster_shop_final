class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :item

  def subtotal
    # quantity * price
    if get_discount
      discounted_subtotal
    else
      quantity * price
    end
  end

  def fulfill
    update(fulfilled: true)
    item.update(inventory: item.inventory - quantity)
  end

  def fulfillable?
    item.inventory >= quantity
  end

  def discounted_subtotal
    discount = discount_percentage.fdiv(100)
    subtotal = self.quantity * Item.find(item_id).price
    subtotal -= discount * subtotal
    subtotal.round(2)
  end

  def get_discount
    item = Item.find(self.item_id)
    item.merchant.discounts.where(item_minimum: self.quantity).order('percent desc').first
  end

  def discount_percentage
    self.get_discount.percent
  end
end
