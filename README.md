# Acme Widget Co - Shopping Basket

A Ruby implementation of a shopping basket system for Acme Widget Co, featuring configurable product catalogues, delivery charge rules, and promotional offers.

## Design Principles

This solution demonstrates:

- **Separation of Concerns**: Each class has a single, well-defined responsibility
- **Dependency Injection**: The `Basket` class receives its dependencies (catalogue, delivery calculator, offers) through its constructor, making it easy to test and configure
- **Strategy Pattern**: The `Offer` base class provides an extensible interface for implementing different promotional strategies
- **Small, Accurate Interfaces**: Each class exposes only what's necessary and maintains clear boundaries
- **Encapsulation**: Internal state is private, and classes expose only their public interfaces

## Architecture

### Core Classes

#### `Product`
Represents a product with code, name, and price. Implements equality and hash methods for proper collection behavior.

#### `Catalogue`
Manages the product catalogue. Provides a `find(product_code)` method to retrieve products by code.

#### `Offer` (Base Class)
Abstract interface for promotional offers using the Strategy pattern. All offers implement the `apply(items)` method.

#### `BuyOneGetOneHalfPriceOffer`
Concrete implementation of the "buy one, get second half price" offer. Can be instantiated for any product code, making it reusable.

#### `DeliveryChargeCalculator`
Calculates delivery charges based on configurable threshold rules. Rules are defined as an array of `{threshold, charge}` hashes and automatically sorted by threshold.

#### `Basket`
Main interface for the shopping basket. Initialized with:
- `catalogue`: Product catalogue
- `delivery_calculator`: Delivery charge calculator
- `offers`: Array of offer objects (optional)

Public methods:
- `add(product_code)`: Add a product to the basket
- `total`: Calculate the total cost including offers and delivery

## How It Works

1. **Adding Items**: Products are added by code using `basket.add(product_code)`
2. **Calculating Total**:
   - Calculate subtotal from all items
   - Apply all offers to calculate total discount
   - Subtract discount from subtotal
   - Calculate delivery charge based on discounted subtotal
   - Add delivery charge to get final total

## Assumptions

1. **Offer Application Order**: Multiple offers are applied additively (discounts sum)
2. **Delivery Calculation**: Delivery charges are calculated on the subtotal *after* offers are applied
3. **Price Precision**: Final totals are truncated (not rounded) to 2 decimal places. For example, $54.375 becomes $54.37, not $54.38. This is implemented using floor truncation.
4. **Product Codes**: Case-sensitive (e.g., "R01" ≠ "r01")
5. **Invalid Products**: Adding a non-existent product code raises an `ArgumentError`
6. **Offer Scope**: The "buy one get second half price" offer applies independently per product code
7. **Currency**: All prices are in USD
8. **Decimal Precision**: Uses `BigDecimal` internally to avoid floating-point precision errors in monetary calculations

## Usage

### Running the Example

```bash
ruby example.rb
```

This demonstrates all four test cases from the specification.

### Running Tests

```bash
ruby test/test_basket.rb
ruby test/test_product.rb
ruby test/test_catalogue.rb
ruby test/test_delivery_charge_calculator.rb
ruby test/test_buy_one_get_one_half_price_offer.rb
```

Or run all tests:

```bash
ruby -Ilib:test test/test_*.rb
```

### Creating a Basket

```ruby
require_relative 'lib/basket'
require_relative 'lib/catalogue'
require_relative 'lib/product'
require_relative 'lib/delivery_charge_calculator'
require_relative 'lib/buy_one_get_one_half_price_offer'

# Define products
products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
]

# Create catalogue
catalogue = Catalogue.new(products)

# Define delivery rules
delivery_calculator = DeliveryChargeCalculator.new([
  { threshold: 0, charge: 4.95 },   # Under $50
  { threshold: 50, charge: 2.95 },  # $50-$90
  { threshold: 90, charge: 0.00 }   # $90+
])

# Define offers
offers = [BuyOneGetOneHalfPriceOffer.new('R01')]

# Create basket
basket = Basket.new(
  catalogue: catalogue,
  delivery_calculator: delivery_calculator,
  offers: offers
)

# Add items
basket.add('R01')
basket.add('G01')

# Get total
puts basket.total  # => 60.85
```

## Extending the System

### Adding New Offers

Create a new class inheriting from `Offer`:

```ruby
class BuyTwoGetOneFreeOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items)
    matching_items = items.select { |item| item.code == @product_code }
    free_items = matching_items.count / 3
    free_items * matching_items.first&.price.to_f
  end
end
```

Then add it to the offers array when creating a basket.

### Modifying Delivery Rules

Simply provide different rules when creating the `DeliveryChargeCalculator`:

```ruby
delivery_calculator = DeliveryChargeCalculator.new([
  { threshold: 0, charge: 9.99 },
  { threshold: 100, charge: 0.00 }
])
```

### Adding New Products

Add products to the catalogue array:

```ruby
products << Product.new(code: 'Y01', name: 'Yellow Widget', price: 15.99)
```

## Test Coverage

The solution includes comprehensive unit tests for:
- Product equality and hashing
- Catalogue lookup and error handling
- Delivery charge calculation at various thresholds
- Offer application with different item combinations
- Basket total calculation for all specification examples
- Edge cases (empty basket, invalid products, baskets without offers)

## Requirements

- Ruby 2.7+ (uses frozen string literals)
- No external dependencies (uses only standard library and minitest)
