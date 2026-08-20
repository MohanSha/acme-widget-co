# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/delivery_charge_calculator'

class TestDeliveryChargeCalculator < Minitest::Test
  def setup
    @calculator = DeliveryChargeCalculator.new([
      { threshold: 0, charge: 4.95 },
      { threshold: 50, charge: 2.95 },
      { threshold: 90, charge: 0.00 }
    ])
  end

  def test_charge_under_50
    assert_equal 4.95, @calculator.calculate(0)
    assert_equal 4.95, @calculator.calculate(25.00)
    assert_equal 4.95, @calculator.calculate(49.99)
  end

  def test_charge_between_50_and_90
    assert_equal 2.95, @calculator.calculate(50.00)
    assert_equal 2.95, @calculator.calculate(75.00)
    assert_equal 2.95, @calculator.calculate(89.99)
  end

  def test_charge_90_and_above
    assert_equal 0.00, @calculator.calculate(90.00)
    assert_equal 0.00, @calculator.calculate(100.00)
    assert_equal 0.00, @calculator.calculate(999.99)
  end
end
