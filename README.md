# Bloom Filter Implementation in Ruby

This repository contains the source code for my blog post on [building a Bloom filter in Ruby](https://mohllal.github.io/building-a-bloom-filter-in-ruby/).

## Usage

```ruby
require_relative 'lib/bloom_filter'

# Create a new Bloom filter with capacity for ~1000 items and 0.01 false positive probability
filter = BloomFilter.new(capacity: 1000, false_positive_probability: 0.01)

# Add elements to the filter
filter.add("apple")
filter.add("orange")
filter.add("banana")

# Check if elements exist in the filter
puts filter.include?("apple")  # true
puts filter.include?("grape")  # false (unless false positive)
```

## Example Usage

Run `ruby example.rb` to see how the Bloom filter works:

- Creates a filter for 50 items but adds 100+ items.
- Tests that there are no false negatives (guaranteed property).
- Demonstrates the actual vs. expected false positive rate.
