require 'set'
require 'delegate'

if defined?(Rails) && defined?(Rails::Engine)
  require 'binflip_rails'
end

class Binflip

  def self.rollout?
    defined?(Rollout) == 'constant'
  end

  def initialize(redis=nil)
    if Binflip.rollout?
      @redis = redis
      @source = SimpleDelegator.new(Rollout.new(redis))
    end
  end

  def active?(feature, user=nil)
    if environment_active?(feature) && @source && user
      @source.active?(feature, user)
    else
      environment_active?(feature)
    end
  end

  def active_features(user=nil)
    active_features ||= {}
    features.each do |feature|
      active_features[feature] = active?(feature, user)
    end
    active_features
  end

  def activate_group(feature, group)
    @source.activate_group(feature, group)
    feature_set_add(feature)
  end

  def activate_user(feature, user)
    @source.activate_user(feature, user)
    feature_set_add(feature)
  end

  def cleanup_feature_set!
    features_rollout.each do |feature|
      unused_feature = { :percentage => 0, :groups => [], :users => [] }
      feature_set_del(feature) if (@source.info(feature) == unused_feature)
    end
  end

  def method_missing(meth, *args, &block)
    if @source
      @source.send(meth, *args, &block)
      cleanup_feature_set! if (meth =~ /(:de)?activate/)
    else
      super
    end
  end

  private

  def environment_key_pattern
    /^FEATURE_/
  end

  def environment_key(feature)
    ("FEATURE_%s" % feature).upcase
  end

  def environment_active?(feature)
    ENV[environment_key(feature)] == '1'
  end

  
  def feature_set_purge
    @redis.del(feature_set_key) if Binflip.rollout?
  end

  def feature_set_del(feature)
    @redis.srem(feature_set_key, feature) if Binflip.rollout?
  end

  def feature_set_add(feature)
    @redis.sadd(feature_set_key, feature) if Binflip.rollout?
  end

  def feature_set_key
    'features'
  end


  # Set of all feature keys
  def features
    features_rollout + features_environment
  end
  
  def features_rollout
    @redis.smembers(feature_set_key).to_set
  end

  def features_environment
    ENV.keys.select{|k| k =~ environment_key_pattern}.to_set
  end
end
