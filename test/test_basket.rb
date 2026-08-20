# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/basket'
require_relative '../lib/catalogue'
require_relative '../lib/product'
require_relative '../lib/delivery_charge_calculator'
require_relative '../lib/buy_one_get_one_half_price_offer'

class TestBasket < Minitest::Test
  def setup
    # Setup products
    products = [
      Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
      Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
      Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
    ]

    @catalogue = Catalogue.new(products)

    # Setup delivery rules
    # Orders < $50 = $4.95
    # Orders < $90 = $2.95
    # Orders >= $90 = free
    @delivery_calculator = DeliveryChargeCalculator.new([
      { threshold: 0, charge: 4.95 },
      { threshold: 50, charge: 2.95 },
      { threshold: 90, charge: 0.00 }
    ])

    # Setup offers
    @offers = [BuyOneGetOneHalfPriceOffer.new('R01')]
  end

  def test_basket_b01_g01
    basket = create_basket
    basket.add('B01')
    basket.add('G01')

    # B01: $7.95, G01: $24.95 = $32.90
    # Under $50, delivery: $4.95
    # Total: $37.85
    assert_equal 37.85, basket.total
  end

  def test_basket_r01_r01
    basket = create_basket
    basket.add('R01')
    basket.add('R01')

    # R01: $32.95 x 2 = $65.90
    # Offer: Second R01 half price = -$16.475
    # Subtotal: $49.425
    # Under $50, delivery: $4.95
    # Total: $54.375 → $54.37
    assert_equal 54.37, basket.total
  end

  def test_basket_r01_g01
    basket = create_basket
    basket.add('R01')
    basket.add('G01')

    # R01: $32.95, G01: $24.95 = $57.90
    # Between $50 and $90, delivery: $2.95
    # Total: $60.85
    assert_equal 60.85, basket.total
  end

  def test_basket_b01_b01_r01_r01_r01
    basket = create_basket
    basket.add('B01')
    basket.add('B01')
    basket.add('R01')
    basket.add('R01')
    basket.add('R01')

    # B01: $7.95 x 2 = $15.90
    # R01: $32.95 x 3 = $98.85
    # Subtotal: $114.75
    # Offer: Second R01 half price = -$16.475
    # Subtotal after discount: $98.275
    # >= $90, delivery: free
    # Total: $98.275 → $98.27
    assert_equal 98.27, basket.total
  end

  def test_empty_basket
    basket = create_basket
    # Empty basket should only have delivery charge
    assert_equal 4.95, basket.total
  end

  def test_invalid_product_code
    basket = create_basket
    assert_raises(ArgumentError) do
      basket.add('INVALID')
    end
  end

  def test_basket_without_offers
    basket = Basket.new(
      catalogue: @catalogue,
      delivery_calculator: @delivery_calculator,
      offers: []
    )

    basket.add('R01')
    basket.add('R01')

    # Without offer: $32.95 x 2 = $65.90
    # Between $50 and $90, delivery: $2.95
    # Total: $68.85
    assert_equal 68.85, basket.total
  end

  private

  def create_basket
    Basket.new(
      catalogue: @catalogue,
      delivery_calculator: @delivery_calculator,
      offers: @offers
    )
  end
end
