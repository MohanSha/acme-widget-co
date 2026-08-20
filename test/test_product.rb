# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/product'

class TestProduct < Minitest::Test
  def test_product_creation
    product = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)

    assert_equal 'R01', product.code
    assert_equal 'Red Widget', product.name
    assert_equal 32.95, product.price
  end

  def test_product_equality
    product1 = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)
    product2 = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)
    product3 = Product.new(code: 'G01', name: 'Green Widget', price: 24.95)

    assert_equal product1, product2
    refute_equal product1, product3
  end

  def test_product_hash
    product1 = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)
    product2 = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)

    assert_equal product1.hash, product2.hash
  end
end
