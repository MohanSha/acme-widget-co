# frozen_string_literal: true

require_relative 'product'

# Manages the product catalogue
class Catalogue
  def initialize(products)
    @products = products.each_with_object({}) do |product, hash|
      hash[product.code] = product
    end
  end

  def find(product_code)
    @products[product_code] || raise(ArgumentError, "Product #{product_code} not found")
  end
end
