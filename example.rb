#!/usr/bin/env ruby

require_relative 'lib/bloom_filter'

# Example usage of the Bloom filter

# Create a filter with capacity for 50 items and 1% false positive rate
filter = BloomFilter.new(capacity: 50, false_positive_probability: 0.01)

puts "Adding elements to the bloom filter..."
(0..100).each do |i|
  filter.add("item_#{i}")
end

puts "\nBloom filter statistics:"
puts "  Capacity: #{filter.capacity}"
puts "  Bit array size: #{filter.size} bits"
puts "  Number of hash functions: #{filter.hash_count}"
puts "  Current fill ratio: #{(filter.fill_ratio * 100).round(2)}%"
puts "  Current false positive probability: #{(filter.current_false_positive_probability * 100).round(4)}%"

puts "\nChecking for elements that were added (should all be true)..."
false_negatives = 0
(0..100).each do |i|
  result = filter.include?("item_#{i}")
  false_negatives += 1 unless result
end
puts "  All present: #{false_negatives == 0 ? 'Yes' : 'No'}"
puts "  False negatives: #{false_negatives} (should be 0)"

puts "\nChecking for elements that were NOT added (should mostly be false)..."
false_positives = 0
(101..200).each do |i|
  result = filter.include?("item_#{i}")
  false_positives += 1 if result
end
puts "  False positives: #{false_positives} out of 100"
puts "  False positive rate: #{false_positives}%"
puts "  Expected false positive rate: #{(filter.current_false_positive_probability * 100).round(2)}%"
