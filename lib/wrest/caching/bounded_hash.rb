module Wrest::Caching
  class BoundedHash

    def initialize(limit = 1000)
      @bounded_hash = Hash.new
      @size = 0
      @limit = limit
    end

    def limit
      @limit
    end

    def size
      @size
    end

    def [](key)
      if @bounded_hash.has_key?(key)
        @bounded_hash[key]
      end
    end

    def []=(key, value)
      if @size < @limit
        @size += 1
        @bounded_hash[key] = value
      else
        Wrest.logger.warn("<- (Wrest::Caching::BoundedHash) cache is full")
      end
    end

    # should be compatible with Hash - return value of the deleted element.
    def delete(key)
      value = self[key]

      @size -= 1
      @bounded_hash.delete key

      return value
    end
  end
end
