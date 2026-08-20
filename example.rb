#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'lib/basket'
require_relative 'lib/catalogue'
require_relative 'lib/product'
require_relative 'lib/delivery_charge_calculator'
require_relative 'lib/buy_one_get_one_half_price_offer'

# Setup product catalogue
products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
]

catalogue = Catalogue.new(products)

# Setup delivery charge rules
# Orders under $50 cost $4.95
# Orders under $90 cost $2.95
# Orders $90 or more have free delivery
delivery_calculator = DeliveryChargeCalculator.new([
  { threshold: 0, charge: 4.95 },
  { threshold: 50, charge: 2.95 },
  { threshold: 90, charge: 0.00 }
])

# Setup offers
# Buy one red widget, get the second half price
offers = [BuyOneGetOneHalfPriceOffer.new('R01')]

# Example baskets
examples = [
  { items: %w[B01 G01], expected: 37.85 },
  { items: %w[R01 R01], expected: 54.37 },
  { items: %w[R01 G01], expected: 60.85 },
  { items: %w[B01 B01 R01 R01 R01], expected: 98.27 }
]

puts "Acme Widget Co - Basket Examples\n\n"

examples.each do |example|
  basket = Basket.new(
    catalogue: catalogue,
    delivery_calculator: delivery_calculator,
    offers: offers
  )

  example[:items].each { |code| basket.add(code) }

  total = basket.total
  status = total == example[:expected] ? '✓' : '✗'

  puts "Items: #{example[:items].join(', ')}"
  puts "Total: $#{format('%.2f', total)} (Expected: $#{format('%.2f', example[:expected])}) #{status}"
  puts
end
