require_relative 'basket'
# A Class to support the generation of a total based on promotional rules
# and the items which have been added to the basket.
#
# Example:
#   co = Checkout.new(promotional_rules)
#   co.scan(item)
#   co.scan(item)
#   price = co.total
class Checkout
  # +rules+:: The promotional rules to be applied when total is called
  attr_reader :rules,

              # The collection of items that have been added via +scan+
              :basket

  # === PARAMS::
  # +rules+:: The promotional rules which will be aplplied when total is called.
  def initialize(rules)
    @rules = rules
    @basket = Basket.new
  end

  def scan(item)
    @basket << item
  end
end
