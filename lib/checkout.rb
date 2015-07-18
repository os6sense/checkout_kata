require_relative 'purchases'
require_relative 'product'
require_relative 'promotional_rules'
require_relative 'pricing'

# A Class to support the generation of a total based on promotional rules
# and the items purchased. items are expected to be instances of +Product+,
# which when scanned is added to +purcases+ as an instance of +Purchase+.
#
# Promotional rules can either apply to a product or an entire transaction.
# see promotional_rules.rb and its spec for more detail.
#
# == EXAMPLE:
#   co = Checkout.new(promotional_rules)
#   co.scan(item)
#   co.scan(item)
#   price = co.total
class Checkout
  attr_reader :rules
  attr_reader :purchases

  # Constructor; promotional rules must be supplied when creating an instance.
  #
  # ==== Params
  # * +rules+:: An instance of PromotionalRules; The promotional rules which
  #             will be applied to products and the transaction when +total+
  #             is called.
  def initialize(rules)
    @products, @purchases, @rules = Products.new, Purchases.new, rules
  end

  # Add an item to the checkout. An optional +qty+ can be specified for
  # multiple items.
  # ==== Params
  # * +product+:: An instance of product; it will be added to +purchases+
  #               as a new Purchase. If the same product has already
  #               been purchased the quanitity of the existing product will
  #               be increased.
  # * +qty+::     The quantity of the product to add (default: 1)
  def scan(product, qty = 1)
    @purchases[product].quantity += qty
  end

  # Calculate the total price of the transaction based on the products scanned
  # and any PromotionalRules applying to the individual products and
  # the transaction as a whole.
  #
  # ==== Params
  # * +base_cost+:: An amount to which the cost of purchases will be added to.
  #                 (default: 0)
  def total(base_cost = 0)
    base_cost = Money.new(base_cost)

    base_cost += @purchases.each_value.inject(base_cost) do |a, e|
      a + e.price + product_discount(e)
    end

    base_cost + transaction_discounts(base_cost)
  end

  private

  def product_discount(purchase)
    @rules.apply(purchase, @purchases)
  end

  def transaction_discounts(cost)
    @rules.apply(cost, @purchases)
  end
end
