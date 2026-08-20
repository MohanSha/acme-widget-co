# frozen_string_literal: true

# Base interface for offers using Strategy pattern
class Offer
  # Apply the offer to a collection of items
  # @param items [Array<Product>] The items in the basket
  # @return [Float] The discount amount to apply
  def apply(items)
    raise NotImplementedError, "#{self.class} must implement #apply"
  end
end
