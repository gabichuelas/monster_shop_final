class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def discounted_subtotal(item_id)
    # create model spec for this
    discount = discount_percentage(item_id).fdiv(100)
    subtotal = @contents[item_id.to_s] * Item.find(item_id).price
    subtotal -= discount * subtotal
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def get_discount(item_id)
    item = Item.find(item_id)
    discount = Discount.where(merchant_id: item.merchant_id, item_minimum: count_of(item_id)).order('percent desc').first
  end

  def discount_percentage(item_id)
    get_discount(item_id).percent
  end
end
