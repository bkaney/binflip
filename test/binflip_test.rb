require 'minitest/autorun'
require 'minitest/spec'

require 'bundler/setup'
require 'mocha'
require 'pry'
require 'rollout'
require 'redis'
require 'binflip'

describe Binflip do

  describe "without rollout" do

    before do
      Binflip.stubs(:rollout?).returns(false)

      @binflip = Binflip.new
      ENV['FEATURE_X'] = "1"
      ENV['FEATURE_Y'] = "0"
    end

    it "should be active" do
      @binflip.active?(:x).must_equal true
    end

    it "should not be active" do
      @binflip.active?(:y).must_equal false
    end

    it "should not be active for unspecified" do
      @binflip.active?(:z).must_equal false
    end

    describe "with Rollout" do
      before do
        Binflip.stubs(:rollout?).returns(true)
        Redis.new.flushdb

        @redis = Redis.new
        @binflip = Binflip.new(@redis)
        ENV['FEATURE_X'] = "1"
        ENV['FEATURE_Y'] = "0"
      end

      it "must be true if the environment is true and rollout is true" do
        @binflip.activate_user(:x, stub(:id => 51))
        @binflip.active?(:x, stub(:id => 51)).must_equal true
      end

      it "must be true if the environment is true and rollout is false" do
        @binflip.active?(:x, stub(:id => 51)).must_equal false
      end

      it "must be false if the environment is false" do
        binding.pry
        @binflip.activate_user(:x, stub(:id => 51))
        @binflip.active?(:y, stub(:id => 51)).must_equal false
      end

    end

  end

end
