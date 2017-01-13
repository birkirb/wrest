# Copyright 2009 Sidu Ponnappa

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at native://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

module Wrest
  module Caching
    # Loads the Memcached caching back-end and the Dalli gem 
    def self.enable_memcached
      require "wrest/caching/memcached"
    end
    
    # Loads the Redis caching back-end and the Redis gem 
    def self.enable_redis
      require "wrest/caching/redis"
    end

    # Loads the BoundedHash caching back-end
    def self.enable_bounded_hash
      require "wrest/caching/bounded_hash"
    end

    # Loads the ElastiCache caching back-end and the dalli-elasticache gem
    def self.enable_elasticache
      require "wrest/caching/elasti_cache"
    end

    # Configures Wrest to cache all requests. This will use a Ruby Hash.
    # WARNING: This should NEVER be used in a real environment. The Hash will 
    # keep growing since Wrest does not limit the size of a cache store.
    #
    # Please switch to the memcached or redis back-end for production use.
    def self.default_to_hash!
      self.default_store = Hash.new
    end

    # Default Wrest to using memcached for caching requests.
    def self.default_to_memcached!
      self.enable_memcached
      self.default_store = Wrest::Caching::Memcached.new 
    end
    
    # Default Wrest to using redis for caching requests.
    # 
    # Options to configuring the redis gem can be passed as arguments.
    def self.default_to_redis!(redis_options = {})
      self.enable_redis
      self.default_store = Wrest::Caching::Redis.new(redis_options)
    end

    # Default Wrest to using bounded for caching requests.
    def self.default_to_bounded_hash!
      self.enable_bounded_hash
      self.default_store = Wrest::Caching::BoundedHash.new
    end

    # Default Wrest to using elasticache for caching requests.
    def self.default_to_elasticache!
      self.enable_elasticache
      self.default_store = Wrest::Caching::ElastiCache.new
    end

    # Assign the default cache store to be used. Default is none.
    def self.default_store=(store)
      @default_store = store 
    end

    # Returns the default store for caching, if any is set.
    def self.default_store
      @default_store
    end
  end
end
