
class PromotionalRules
  attr_reader :product,
              :block

  def initialize(product, &block)
    # is there a standard "Block" exception class?
    fail ArgumentError, 'Block Required' unless block_given?
    @product = product
    @block = block
  end

  def apply(basket)
    @block.call(basket)
  end
end
