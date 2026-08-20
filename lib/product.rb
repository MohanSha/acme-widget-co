# frozen_string_literal: true

# Represents a product in the catalogue
class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price
  end

  def ==(other)
    other.is_a?(Product) && code == other.code
  end

  alias eql? ==

  def hash
    code.hash
  end
end
