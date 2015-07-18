
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
class ProductRule < PromotionalRule
  attr_reader :product

  def initialize(product, trigger, &block)
    @product = product
    super(trigger, &block)
  end
end

# PromotionalRule which applies to the entire basket/transaction
# ==== Example

class TransactionRule < PromotionalRule; end

# Container class for all the rules
class PromotionalRules
  attr_reader :products
  attr_reader :transactions

  def initialize
    @products = Hash.new { |h, k| h[k] = [] }
    @transactions = []
  end

  def add(rule)
    if rule.respond_to?(:product)
      @products[rule.product] << rule
    else
      @transactions << rule
    end
  end

  def apply(p_or_t, purchases)
    if p_or_t.respond_to?(:product)
      apply_rule(@products[p_or_t.product], p_or_t, purchases)
    else
      apply_rule(@transactions, p_or_t, purchases)
    end
  end

  private

  def apply_rule(rule, purchase, purchases)
    rule.inject(0) { |a, e| a + e.apply(purchase, purchases) }
  end
end
