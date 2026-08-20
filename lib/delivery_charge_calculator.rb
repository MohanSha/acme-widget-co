# frozen_string_literal: true

# Calculates delivery charges based on configurable rules
class DeliveryChargeCalculator
  # @param rules [Array<Hash>] Array of rules with :threshold and :charge keys
  #   Rules should be ordered from lowest to highest threshold
  def initialize(rules)
    @rules = rules.sort_by { |rule| rule[:threshold] }
  end

  # Calculate delivery charge based on subtotal
  # @param subtotal [Float] The basket subtotal before delivery
  # @return [Float] The delivery charge
  def calculate(subtotal)
    @rules.reverse_each do |rule|
      return rule[:charge] if subtotal >= rule[:threshold]
    end

    # If no rule matches, return the lowest threshold charge
    @rules.first[:charge]
  end
end
