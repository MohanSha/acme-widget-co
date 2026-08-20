# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/buy_one_get_one_half_price_offer'
require_relative '../lib/product'

class TestBuyOneGetOneHalfPriceOffer < Minitest::Test
  def setup
    @red_widget = Product.new(code: 'R01', name: 'Red Widget', price: 32.95)
    @green_widget = Product.new(code: 'G01', name: 'Green Widget', price: 24.95)
    @offer = BuyOneGetOneHalfPriceOffer.new('R01')
  end

  def test_no_discount_for_empty_basket
    assert_equal 0, @offer.apply([])
  end

  def test_no_discount_for_single_item
    items = [@red_widget]
    assert_equal 0, @offer.apply(items)
  end

  def test_discount_for_two_items
    items = [@red_widget, @red_widget]
    # Second item should be half price: 32.95 * 0.5 = 16.475
    assert_equal 16.475, @offer.apply(items)
  end

  def test_discount_for_three_items
    items = [@red_widget, @red_widget, @red_widget]
    # Second item should be half price: 32.95 * 0.5 = 16.475
    # Third item full price
    assert_equal 16.475, @offer.apply(items)
  end

  def test_discount_for_four_items
    items = [@red_widget, @red_widget, @red_widget, @red_widget]
    # 2nd and 4th items half price: (32.95 * 0.5) * 2 = 32.95
    assert_equal 32.95, @offer.apply(items)
  end

  def test_no_discount_for_different_product
    items = [@green_widget, @green_widget]
    assert_equal 0, @offer.apply(items)
  end

  def test_discount_only_applies_to_matching_product
    items = [@red_widget, @green_widget, @red_widget]
    # Only the two red widgets qualify: 32.95 * 0.5 = 16.475
    assert_equal 16.475, @offer.apply(items)
  end
end
