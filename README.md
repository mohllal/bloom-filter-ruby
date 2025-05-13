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
