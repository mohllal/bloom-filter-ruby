require 'murmurhash3'

class BloomFilter
  attr_reader :size, :hash_count, :capacity, :false_positive_probability

  # Creates a new Bloom filter
  # @param capacity [Integer] Expected number of items to store
  # @param false_positive_probability [Float] Desired false positive probability (between 0 and 1)
  def initialize(capacity: 1000, false_positive_probability: 0.01)
    @capacity = capacity
    @false_positive_probability = false_positive_probability
    
    # Calculate optimal bit array size and number of hash functions
    @size = calculate_size(capacity, false_positive_probability)
    @hash_count = calculate_hash_count(capacity, @size)
    
    # Initialize bit array with zeros
    @bit_array = Array.new(@size, false)
    @item_count = 0
  end

  # Adds an item to the Bloom filter
  # @param item [Object] Item to add to the filter
  # @return [BloomFilter] Returns self for chaining
  def add(item)
    bit_positions(item).each do |position|
      @bit_array[position] = true
    end
    @item_count += 1
    self
  end
  
  # Checks if an item might be in the filter
  # @param item [Object] Item to test
  # @return [Boolean] True if the item might be in the filter, false if it's definitely not
  def include?(item)
    bit_positions(item).all? { |position| @bit_array[position] }
  end
  
  # Returns the current false positive probability based on the load factor
  # @return [Float] Current estimated false positive probability
  def current_false_positive_probability
    (1 - Math.exp(-@hash_count * @item_count.to_f / @size)) ** @hash_count
  end
  
  # Returns the current estimated fill ratio of the bit array
  # @return [Float] Current fill ratio (0 to 1)
  def fill_ratio
    @bit_array.count(true).to_f / @size
  end
  
  private
  
  # Calculates optimal bit array size based on capacity and false positive probability
  # @param capacity [Integer] Expected number of items
  # @param fp_prob [Float] Desired false positive probability
  # @return [Integer] Optimal bit array size
  def calculate_size(capacity, fp_prob)
    # m = -n*ln(p)/(ln(2)^2)
    (-capacity * Math.log(fp_prob) / (Math.log(2)**2)).ceil
  end
  
  # Calculates optimal number of hash functions
  # @param capacity [Integer] Expected number of items
  # @param size [Integer] Bit array size
  # @return [Integer] Optimal number of hash functions
  def calculate_hash_count(capacity, size)
    # k = (m/n)*ln(2)
    ((size.to_f / capacity) * Math.log(2)).ceil
  end
  
  # Generates bit positions for an item using multiple hash functions
  # @param item [Object] Item to hash
  # @return [Array<Integer>] Array of bit positions
  def bit_positions(item)
    item_str = item.to_s
    positions = []

    # Use different seeds to generate two independent hash values
    hash1 = MurmurHash3::V32.str_hash(item_str, 42)
    hash2 = MurmurHash3::V32.str_hash(item_str, 101)
    
    # Use double hashing technique to generate k hash functions
    # This is more efficient than computing k independent hashes
    @hash_count.times do |i|
      # h_i(x) = (hash1(x) + i * hash2(x)) % m
      position = (hash1 + i * hash2) % @size
      positions << position
    end
    
    positions
  end
end
