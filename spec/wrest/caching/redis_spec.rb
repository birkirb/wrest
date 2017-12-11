require "spec_helper"
require 'rspec'

Wrest::Caching.enable_redis

describe Wrest::Caching do
  context "functional", :functional => true do
    let(:redis) { Wrest::Caching::Redis.new }

    context "initialization defaults" do
      it "should always default the options to an empty hash" do
        expect(Redis).to receive(:new).with({})
        client = Wrest::Caching::Redis.new
      end
      
      it "should pass through options received to redis" do
        expect(Redis).to receive(:new).with(:host => "10.0.1.1", :port => 6380, :db => 15)
        client = Wrest::Caching::Redis.new(:host => "10.0.1.1", :port => 6380, :db => 15)
      end
    end

    it "should know how to retrieve a cache entry" do
      request = 'http://localhost:3000/cacheable/can_be_validated/with_last_modified/always_304/1000'
      ok_response = request.to_uri.get
      redis[request] = ok_response
      expect(redis[request]).to eq(ok_response)
    end

    it 'should unmarshall the value when retrieved a cache entry' do
      ok_response = 'http://localhost:3000/cacheable/can_be_validated/with_last_modified/always_304/1000'.to_uri.get
      redis['example-123'] = ok_response

      expect(redis['example-123']).to eq(ok_response)
    end

    it "should set expiry for the cache entry based on response headers" do
      uri_string = 'http://localhost:3000/cacheable/can_be_validated/with_last_modified/always_give_fresh_response/10'
      ok_response = uri_string.to_uri.get
      redis[uri_string] = ok_response
      expect(redis.instance_eval('@redis').ttl(uri_string)).to eq(10)
    end
    
    it "should know how to delete a cache entry" do
      request = 'http://localhost:3000/cacheable/can_be_validated/with_last_modified/always_304/1000'
      ok_response = request.to_uri.get
      redis[request] = ok_response
      redis.delete(request).should == ok_response
    end

    it 'should return nil on delete if the key is not present' do
      expect(redis.delete('not_present_key')).to eq(nil)
    end
  end
end
