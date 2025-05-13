require_relative '../lib/bloom_filter'

describe BloomFilter do
  let(:capacity) { 1000 }
  let(:fp_prob) { 0.01 }
  let(:filter) { BloomFilter.new(capacity: capacity, false_positive_probability: fp_prob) }
  
  describe '#initialize' do
    it 'creates a bloom filter with the specified capacity and false positive probability' do
      expect(filter.capacity).to eq(capacity)
      expect(filter.false_positive_probability).to eq(fp_prob)
    end
    
    it 'calculates bit array size and hash count correctly' do
      # These are approximate values based on the formula
      # m = -n*ln(p)/(ln(2)^2)
      # k = (m/n)*ln(2)
      expected_size = (-capacity * Math.log(fp_prob) / (Math.log(2)**2)).ceil
      expected_hash_count = ((expected_size.to_f / capacity) * Math.log(2)).ceil
      
      expect(filter.size).to eq(expected_size)
      expect(filter.hash_count).to eq(expected_hash_count)
    end
  end
  
  describe '#add and #include?' do
    it 'adds elements to the filter' do
      filter.add('test')
      expect(filter.include?('test')).to be true
    end
    
    it 'returns self when adding an element' do
      expect(filter.add('test')).to eq(filter)
    end
    
    it 'does not produce false negatives' do
      items = ['apple', 'banana', 'orange', 'grape', 'watermelon']
      items.each { |item| filter.add(item) }
      
      items.each do |item|
        expect(filter.include?(item)).to be true
      end
    end
    
    it 'may produce false positives but within acceptable rate' do
      # Add items to the filter
      capacity.times { |i| filter.add("item-#{i}") }
      
      # Check false positive rate on items not in the filter
      false_positives = 0
      test_size = 10000
      
      test_size.times do |i|
        false_positives += 1 if filter.include?("not-in-filter-#{i}")
      end
      
      false_positive_rate = false_positives.to_f / test_size
      
      # The actual rate should be close to the theoretical rate, but may be higher
      # due to the randomized nature of the test. We'll use a safety factor of 2.
      expect(false_positive_rate).to be <= (fp_prob * 2)
    end
  end
  
  describe '#fill_ratio' do
    it 'reports the correct fill ratio' do
      expect(filter.fill_ratio).to eq(0) # Empty filter

      100.times { |i| filter.add("item-#{i}") }

      expect(filter.fill_ratio).to be > 0
      expect(filter.fill_ratio).to be <= 1.0
    end
  end
  
  describe '#current_false_positive_probability' do
    it 'calculates the current false positive probability' do
      expect(filter.current_false_positive_probability).to eq(0) # Empty filter
      
      100.times { |i| filter.add("item-#{i}") }

      expect(filter.current_false_positive_probability).to be > 0
      expect(filter.current_false_positive_probability).to be <= 1.0
    end
  end
end
