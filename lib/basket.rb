# frozen_string_literal: true

require 'bigdecimal'
require 'bigdecimal/util'
require_relative 'catalogue'
require_relative 'delivery_charge_calculator'

# Shopping basket that manages items, applies offers, and calculates total cost
class Basket
  # @param catalogue [Catalogue] Product catalogue
  # @param delivery_calculator [DeliveryChargeCalculator] Delivery charge calculator
  # @param offers [Array<Offer>] Array of offers to apply
  def initialize(catalogue:, delivery_calculator:, offers: [])
    @catalogue = catalogue
    @delivery_calculator = delivery_calculator
    @offers = offers
    @items = []
  end

  # Add a product to the basket by product code
  # @param product_code [String] The product code
  def add(product_code)
    product = @catalogue.find(product_code)
    @items << product
  end

  # Calculate the total cost including offers and delivery
  # @return [Float] Total cost truncated to 2 decimal places
  def total
    subtotal = calculate_subtotal
    discount = calculate_total_discount
    subtotal_after_discount = subtotal - discount
    delivery = @delivery_calculator.calculate(subtotal_after_discount.to_f)

    total_bd = subtotal_after_discount + delivery.to_d
    # Truncate to 2 decimal places (floor) rather than rounding
    ((total_bd * 100).floor / 100.0).round(2)
  end

  private

  def calculate_subtotal
    @items.sum { |item| item.price.to_d }
  end

  def calculate_total_discount
    @offers.sum { |offer| offer.apply(@items).to_d }
  end
end
