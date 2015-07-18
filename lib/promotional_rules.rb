
# Base class for promotional rules. A promotional rule is a class which
# contains a trigger which will be called to test if the rule applies to
# the supplied parameters, and a +discount+ which will calculate how much the
# of a discount should be applied to any product or sale.

# The trigger can be called manually or via  +applies_to?+ or via apply. The
# difference between applies_to and apply  is that applies_to will return true
# or false depending on whether the  trigger applies, whereas apply will first
# call applies_to and then call  the discount.
#
# Note that this is a base class, please see ProductRule and TransactionRule
# for specific examples.

# Both trigger and discount should be callable accepting two parameters, the
# first parameter depends on the type of PromotionalRule, the second parameter
# is an instance of Purchases containing a list of all the iterms purchased.
class PromotionalRule
  attr_reader :trigger,
              :discount

  def initialize(trigger, &block)
    fail ArgumentError, 'Block Required' unless block_given?
    @trigger, @discount = trigger, block
  end

  # Call the trigger to test if the rule should be applied to the item
  def applies_to?(item, transactions)
    trigger.call(item, transactions) ? true : false
  end

  # Calls +applies_to?+ to test if the rule should be applied. If applies_to
  # returns true, the discount is called with the item and transactions params.
  def apply(item, transactions)
    applies_to?(item, transactions) ? discount.call(item, transactions) : 0
  end
end

# Rule which applies only to products. ProductRule adds a product parameter
# as the first parameter which can be used to disamlbiguate it from either
# rules for other products, or rules of a different type (e.g. TransactionRule)
#
# ==== Example
#   # The following example returns a discount equal to the product price
#   # minus 850p per product, if more than 2 of the product have been scanned.
#   trigger = -> (product, _) { product.quantity >= 2 }
#   discount = -> (product, _) do
#     -1 * (product.price - (Money.new(850) * product.quantity))
#   end
#   ProductRule.new(Products.find_by_id('001'), trigger, &discount)
class ProductRule < PromotionalRule
  attr_reader :product

  def initialize(product, trigger, &block)
    @product = product
    super(trigger, &block)
  end
end

# PromotionalRule which applies to the entire basket/transaction
#
# ==== Example
#
#   # The following example would return a 10% discount on tansactions with
#   # a value over 60 pounds.
#   trigger = -> (t_value, _) { t_value > Money.new(6_000) }
#   discount = -> (t_value, _) { -1 * (t_value / 10) }
#   TransactionRule.new(trigger, &discount)
class TransactionRule < PromotionalRule; end

# Container class for all the rules
class PromotionalRules
  def initialize
    @products = Hash.new { |h, k| h[k] = [] }
    @transactions = []
  end

  # Add a rule
  def add(rule)
    @products[key(rule)] << rule
  end

  # Apply the rule
  def apply(elem, purchases)
    apply_rule(@products[key(elem)], elem, purchases)
  end

  private

  def key(e)
    e.respond_to?(:product) ? e.product : :transaction
  end

  def apply_rule(rule, purchase, purchases)
    rule.inject(0) { |a, e| a + e.apply(purchase, purchases) }
  end
end
