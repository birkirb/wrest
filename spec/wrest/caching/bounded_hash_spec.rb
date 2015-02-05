require "spec_helper"
require 'rspec'

Wrest::Caching.enable_bounded_hash

describe Wrest::Caching do
  context 'functional', :functional => true do
    before :each do
      @bounded_hash = Wrest::Caching::BoundedHash.new
      @bounded_hash['abc']='xyz'
    end

    context 'initialization defaults' do
      it 'should always default a cache limit of 1000 requests' do
        instance = Wrest::Caching::BoundedHash.new
        expect(instance.limit).to eql(1000)
      end
    end

    context 'when initialized with a limit' do
      let(:instance) do
        Wrest::Caching::BoundedHash.new(10)
      end

      it 'should use the given cache limit' do
        expect(instance.limit).to eql(10)
      end

      it 'should at most cache requests until the limit is reached' do
        (1..instance.limit+10).each do |request_number|
          instance[request_number] = request_number
          if request_number <= 10
            expect(instance[request_number]).to eql(request_number)
            expect(instance.size).to eql(request_number)
          else
            expect(instance[request_number]).to be_nil
            expect(instance.size).to eql(10)
          end
        end
      end
    end

    it 'should know how to retrieve a cache entry' do
      expect(@bounded_hash['abc']).to eql('xyz')
    end

    it 'should know how to update a cache entry' do
      @bounded_hash['abc'] = '123'
      expect(@bounded_hash['abc']).to eql('123')
    end

    it 'should know how to delete a cache entry' do
      expect(@bounded_hash.delete('abc')).to eql('xyz')
      expect(@bounded_hash['abc']).to be_nil
    end
  end

end
