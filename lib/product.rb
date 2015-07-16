# Product code | Name | Price
# ----------------------------------------------------------
# 001 | Travel Card Holder | £9.25
# 002 | Personalised cufflinks | £45.00
# 003 | Kids T-shirt | £19.95

class Product
  attr_reader :code,
              :description,
              :price

  def initialize(code, product, price)
    @code, @description, @price = code, product, price
  end
end
