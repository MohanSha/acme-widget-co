# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'offer'

# Buy one, get the second half price offer
# When you buy multiple of the same product, every second item is half price
class BuyOneGetOneHalfPriceOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items)
    matching_items = items.select { |item| item.code == @product_code }
    return 0 if matching_items.empty?

    # Sort by price (descending) to discount the cheaper items
    sorted_items = matching_items.sort_by(&:price).reverse

    # Calculate discount for every second item using BigDecimal for precision
    discount = BigDecimal('0')
    sorted_items.each_with_index do |item, index|
      discount += item.price.to_d * BigDecimal('0.5') if (index + 1).even?
    end

    discount.to_f
  end
end
