# Quick Start Guide

## Prerequisites

- Ruby 2.7+ (tested on Ruby 2.6.10)
- No external dependencies required (uses Ruby standard library only)

## Running the Code

### 1. Run the Example Script

See all 4 specification test cases in action:

```bash
ruby example.rb
```

Expected output:
```
Acme Widget Co - Basket Examples

Items: B01, G01
Total: $37.85 (Expected: $37.85) ✓

Items: R01, R01
Total: $54.37 (Expected: $54.37) ✓

Items: R01, G01
Total: $60.85 (Expected: $60.85) ✓

Items: B01, B01, R01, R01, R01
Total: $98.27 (Expected: $98.27) ✓
```

### 2. Run the Tests

Run all unit tests:

```bash
ruby -Ilib:test test/test_*.rb
```

Or run individual test files:

```bash
ruby -Ilib:test test/test_basket.rb
ruby -Ilib:test test/test_product.rb
ruby -Ilib:test test/test_catalogue.rb
ruby -Ilib:test test/test_delivery_charge_calculator.rb
ruby -Ilib:test test/test_buy_one_get_one_half_price_offer.rb
```

### 3. Use as a Library

```bash
irb -Ilib
```

Then in IRB:

```ruby
require 'basket'
require 'catalogue'
require 'product'
require 'delivery_charge_calculator'
require 'buy_one_get_one_half_price_offer'

# Setup
products = [
  Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
]

catalogue = Catalogue.new(products)
delivery_calculator = DeliveryChargeCalculator.new([
  { threshold: 0, charge: 4.95 },
  { threshold: 50, charge: 2.95 },
  { threshold: 90, charge: 0.00 }
])
offers = [BuyOneGetOneHalfPriceOffer.new('R01')]

# Create basket and add items
basket = Basket.new(
  catalogue: catalogue,
  delivery_calculator: delivery_calculator,
  offers: offers
)

basket.add('R01')
basket.add('R01')
basket.total  # => 54.37
```

## Project Structure

```
.
├── README.md                  # Full documentation
├── IMPLEMENTATION_NOTES.md    # Engineering principles & design decisions
├── QUICKSTART.md             # This file
├── example.rb                # Example usage demonstrating test cases
├── lib/                      # Source code
│   ├── product.rb
│   ├── catalogue.rb
│   ├── offer.rb
│   ├── buy_one_get_one_half_price_offer.rb
│   ├── delivery_charge_calculator.rb
│   └── basket.rb
└── test/                     # Unit tests
    ├── test_product.rb
    ├── test_catalogue.rb
    ├── test_delivery_charge_calculator.rb
    ├── test_buy_one_get_one_half_price_offer.rb
    └── test_basket.rb
```

## What's Included

- ✅ Product catalogue system
- ✅ Configurable delivery charge rules
- ✅ Extensible offer/discount system
- ✅ All 4 specification examples working
- ✅ Comprehensive unit tests
- ✅ Clean, readable Ruby code
- ✅ Documentation with examples

## Next Steps

1. Read `README.md` for detailed usage and architecture
2. Check `IMPLEMENTATION_NOTES.md` for design principles
3. Review the code in `lib/` to understand the implementation
4. Run the tests to see everything in action
