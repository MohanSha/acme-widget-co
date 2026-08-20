# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/catalogue'
require_relative '../lib/product'

class TestCatalogue < Minitest::Test
  def setup
    @products = [
      Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
      Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
      Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
    ]

    @catalogue = Catalogue.new(@products)
  end

  def test_find_existing_product
    product = @catalogue.find('R01')

    assert_equal 'R01', product.code
    assert_equal 'Red Widget', product.name
    assert_equal 32.95, product.price
  end

  def test_find_nonexistent_product
    assert_raises(ArgumentError) do
      @catalogue.find('INVALID')
    end
  end
end
