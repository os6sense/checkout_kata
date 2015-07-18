require_relative '../lib/promotional_rules.rb'


Products.add Product.new('001', 'Travel Card Holder', 925)
Products.add Product.new('002', 'Personalised cufflinks', 4500)
Products.add Product.new('003', 'Kids T-shirt', 1995)

# If you buy 2 or more travel card holders then the price drops to £8.50.
def travel_card_promotion
  trigger = -> (product, _transaction) { product.quantity >= 2 }
  discount = -> (product, _transaction) do
    -1 * (product.price - (Money.new(850) * product.quantity))
  end

  ProductRule.new(Products.find_by_id('001'), trigger, &discount)
end

#def three_for_two_promotion
  #trigger = -> (product, _transaction) { product.quantity >= 3 }
  #discount = -> (product, _transaction) do
    #offer, full = product.quantity.divmod(3)
    #-1 * (product.price * full) + (product.price * 2 * offer)
  #end

  #ProductRule.new(Products.find_by_id('002'), trigger, &discount)
#end

#def five_pounds_off_code_promotion
  #trigger = -> (product, _transaction) { product.quantity >= 3 }
  #discount = -> (product, _transaction) do
    #offer, full = product.quantity.divmod(3)
    #-1 * (product.price * full) + (product.price * 2 * offer)
  #end

  #ProductRule.new(Products.find_by_id('002'), trigger, &discount)
#end

# If you spend over £60, then you get 10% off your purchase
def over_60_pound_promotion
  trigger = -> (transaction_value, _purchases) do
    transaction_value > Money.new(6_000)
  end
  discount = -> ( transaction_value, _purchases) do
    -1 * (transaction_value / 10)
  end

  TransactionRule.new(trigger, &discount)
end

def default_promotions
  PromotionalRules.new.tap do |rules|
    rules.add travel_card_promotion
    rules.add over_60_pound_promotion
    #rules.add three_for_two_promotion
  end
end
