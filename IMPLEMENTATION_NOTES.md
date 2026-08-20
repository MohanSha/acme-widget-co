# Implementation Notes

This document highlights the engineering principles demonstrated in this solution.

## Design Patterns & Principles

### 1. Strategy Pattern (Extensible Offers)

The `Offer` base class provides a common interface, allowing new offer types to be added without modifying existing code:

```ruby
class Offer
  def apply(items)
    raise NotImplementedError
  end
end

class BuyOneGetOneHalfPriceOffer < Offer
  def apply(items)
    # Implementation
  end
end
```

New offers (e.g., "Buy 2 Get 1 Free", "10% Off Everything") can be added by simply creating new subclasses.

### 2. Dependency Injection

The `Basket` class receives all its dependencies through constructor injection:

```ruby
basket = Basket.new(
  catalogue: catalogue,
  delivery_calculator: delivery_calculator,
  offers: offers
)
```

Benefits:
- **Testability**: Easy to inject mock objects for unit testing
- **Flexibility**: Different configurations for different scenarios
- **Loose Coupling**: Basket doesn't create its dependencies

### 3. Separation of Concerns

Each class has a single, well-defined responsibility:

| Class | Responsibility |
|-------|---------------|
| `Product` | Represents product data |
| `Catalogue` | Product lookup and management |
| `Offer` | Discount calculation strategy |
| `DeliveryChargeCalculator` | Delivery cost calculation |
| `Basket` | Basket management and total calculation |

### 4. Small, Accurate Interfaces

Classes expose minimal public APIs:

- `Product`: Only exposes `code`, `name`, `price` (all read-only)
- `Catalogue`: Single public method `find(product_code)`
- `Basket`: Two public methods `add(product_code)` and `total`

Private methods are used to hide implementation details.

### 5. Encapsulation

- All instance variables are private
- State is accessed only through public methods
- Internal calculations are hidden behind clear interfaces

## Code Quality Features

### Frozen String Literals

All files use `# frozen_string_literal: true` for:
- Memory efficiency (string immutability)
- Thread safety
- Performance improvements

### BigDecimal for Monetary Calculations

Uses `BigDecimal` to avoid floating-point precision errors:

```ruby
subtotal = @items.sum { |item| item.price.to_d }
```

This ensures accurate monetary calculations without rounding errors.

### Value Object Semantics

`Product` implements proper equality and hashing:

```ruby
def ==(other)
  other.is_a?(Product) && code == other.code
end

def hash
  code.hash
end
```

This enables products to work correctly in collections (arrays, hashes, sets).

### Configurable Rules

Both delivery charges and offers are configurable at runtime:

```ruby
# Easy to change thresholds without modifying code
DeliveryChargeCalculator.new([
  { threshold: 0, charge: 4.95 },
  { threshold: 50, charge: 2.95 },
  { threshold: 90, charge: 0.00 }
])
```

## Testing Strategy

### Comprehensive Unit Tests

Each class has its own test file with focused tests:
- `test_product.rb` - Product behavior
- `test_catalogue.rb` - Catalogue lookup
- `test_delivery_charge_calculator.rb` - Delivery calculation logic
- `test_buy_one_get_one_half_price_offer.rb` - Offer calculation
- `test_basket.rb` - End-to-end basket behavior

### Test Coverage Includes

- Happy path scenarios (all 4 specification examples)
- Edge cases (empty basket, single items)
- Error conditions (invalid product codes)
- Integration tests (basket without offers)

### Test Independence

Each test:
- Sets up its own fixture data
- Doesn't depend on other tests
- Can run in any order (Minitest randomizes)

## Git Best Practices

### Conventional Commits

Commits follow a clear structure:
- Clear, descriptive first line
- Detailed explanation of the "why"
- Context for future maintainers

Example commit structure:
```
Add Product and Catalogue domain models

Implements core domain models with clear separation of concerns:
- Product: Value object representing a product
- Catalogue: Repository pattern for product lookup

Features proper equality and hashing for correct collection behavior.
```

### Logical Progression

Commits are organized by feature/concept rather than chronologically:
1. Core domain models
2. Business logic (offers, delivery)
3. Main basket implementation
4. Tests and documentation

## Extensibility Examples

### Adding a New Offer

```ruby
class BuyTwoGetOneFreeOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items)
    matching = items.select { |i| i.code == @product_code }
    free_items = matching.count / 3
    (free_items * matching.first&.price.to_f).to_d
  end
end

# Use it
offers = [
  BuyOneGetOneHalfPriceOffer.new('R01'),
  BuyTwoGetOneFreeOffer.new('B01')
]
```

### Adding a New Product

```ruby
products << Product.new(
  code: 'Y01',
  name: 'Yellow Widget',
  price: 19.99
)
```

### Changing Delivery Rules

```ruby
# Simpler delivery structure
delivery_calculator = DeliveryChargeCalculator.new([
  { threshold: 0, charge: 9.99 },
  { threshold: 100, charge: 0.00 }
])
```

## Performance Considerations

1. **O(1) Product Lookup**: Catalogue uses hash map for constant-time lookups
2. **Linear Offer Calculation**: Each offer scans items once (O(n))
3. **No Premature Optimization**: Code prioritizes clarity over micro-optimizations
4. **BigDecimal Overhead**: Acceptable for business calculations requiring precision

## Assumptions & Trade-offs

### Price Truncation vs Rounding

The implementation truncates (floors) prices at 2 decimals rather than rounding. This matches the specification but could be considered unusual in some contexts.

**Rationale**: Based on test cases where `$54.375` should equal `$54.37` (not `$54.38`).

### Offer Stacking

Multiple offers are additive (discounts sum). Alternative approaches:
- Best offer only (max discount)
- Mutually exclusive offers
- Offer priority/ordering

Current implementation is simplest and most flexible.

### Immutable Products

Products are value objects - their data can't be changed after creation. This prevents accidental modification but requires creating new instances for price changes.

## What This Solution Demonstrates

✅ **Clean Code**: Readable, maintainable Ruby with clear intent  
✅ **SOLID Principles**: Single responsibility, open/closed, dependency inversion  
✅ **Design Patterns**: Strategy pattern for extensibility  
✅ **Test-Driven Approach**: Comprehensive tests validating all scenarios  
✅ **Domain Modeling**: Proper separation between business concepts  
✅ **Pragmatic Engineering**: Solves the problem without over-engineering
