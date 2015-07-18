require_relative './price.rb'
require_relative './promotional_rules.rb'

# Provides an abstration for products/items that are added to the checkout.
# A product has a code, name and price. As an alternative to constructing
# new products, an Instance of +Products+ can be used to find existing
# products by its id. E.g
#
# ==== Example
#   products.create
#   products.find_by_id('001')
class Product
  attr_reader :code,
              :description,
              :price

  # Constructor; +code+, +description+ and +price+ are all required.
  #
  # === Params
  # +code+::         The identifier for the product e.g. '001'
  # +description+::  A short description 'Glistening perls'
  # +price+::        The price of the product *must* be an integer
  #                  (e.g. 100 vs 1.0 to represent &pound;1)
  def initialize(code, description, price)
    fail ArgumentError, 'Price must be an integer' unless price.is_a? Integer
    @code, @description = code, description
    @price = Money.new(price)
  end
end

# Simple wrapper interface to a +Product+ collection.
class Products
  @products = {}

  class << self
    # Find a product in the collection
    def find(product)
      find_by_id(product.code)
    end

    # Find a product by its code.
    def find_by_code(product_code)
      @products[product_code]
    end
    alias_method :find_by_id, :find_by_code

    # add a +Product+ to the collection.
    def add(product)
      @products[product.code] = product
    end
  end
end
