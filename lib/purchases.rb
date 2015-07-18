require 'forwardable'

# An adbstraction to prepesent a product purchase. Provides +quantity+
# accessor to alter the quantity of a particular product being purchased and
# a +price+ method which calculates the TOTAL price based on the product price
# and quantity purchased.
#
# === EXAMPLE:
#   purchase = Purchase.new(Products.find_by_id('001'), 10)
class Purchase
  attr_reader :product

  attr_accessor :quantity

  # +product+: An instance of Product, the product being purchased.
  # +quantity+: The quantity being purchased (default: 0)
  def initialize(product, quantity = 0)
    @product, @quantity = product, quantity
  end

  # calculate the price of the purchase based upon product price and quantity
  def price
    @product.price * quantity
  end
end

# Container class for products which are scanned in via Checkout
class Purchases
  extend Forwardable
  def_delegators :@purchases,
                 :key?, :each, :each_value, :[], :[]=, :include?

  def initialize
    @purchases = Hash.new { |h, k| h[k] = Purchase.new(k) }
  end
end
