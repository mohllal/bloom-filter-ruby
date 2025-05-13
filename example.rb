#!/usr/bin/env ruby

require_relative 'lib/bloom_filter'

# Example usage of the Bloom filter

# Create a filter with capacity for 1000 items and 1% false positive rate
filter = BloomFilter.new(capacity: 1000, false_positive_probability: 0.01)

# Add some elements
puts "Adding elements to the bloom filter..."
%w[apple banana orange mango strawberry].each do |fruit|
  filter.add(fruit)
  puts "  Added: #{fruit}"
end

# Check for existence
puts "\nChecking for elements in the bloom filter:"
%w[apple grape orange pear blueberry strawberry].each do |fruit|
  result = filter.include?(fruit) ? "might be" : "definitely not"
  puts "  '#{fruit}' is #{result} in the filter"
end

# Print statistics
puts "\nBloom filter statistics:"
puts "  Capacity: #{filter.capacity}"
puts "  Bit array size: #{filter.size} bits"
puts "  Number of hash functions: #{filter.hash_count}"
puts "  Current fill ratio: #{(filter.fill_ratio * 100).round(2)}%"
puts "  Current false positive probability: #{(filter.current_false_positive_probability * 100).round(4)}%"
