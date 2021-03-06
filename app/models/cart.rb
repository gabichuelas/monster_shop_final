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
    @contents.reduce(0.0) do |gt, (item_id, quantity)|
      if get_discount(item_id)
        gt += discounted_subtotal(item_id)
      else
        gt += subtotal_of(item_id)
      end
      gt
    end
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def discounted_subtotal(item_id)
    discount = discount_percentage(item_id).fdiv(100)
    subtotal = @contents[item_id.to_s] * Item.find(item_id).price
    subtotal -= discount * subtotal
  end

  def get_discount(item_id)
    item = Item.find(item_id)
    item.merchant.discounts.where('item_minimum <= ?', count_of(item_id)).order('percent desc').first
  end

  def discount_percentage(item_id)
    get_discount(item_id).percent
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end
end
