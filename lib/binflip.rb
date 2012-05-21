require 'set'

if defined?(Rails) && defined?(Rails::Engine)
  require 'binflip_rails'
end

class FauxRedis
  def smembers(*_); []; end
  def sadd(*_); true; end
  def srem(*_); true; end
  def del(*_); 0; end
end

class Binflip
  @rollout = false

  def initialize(rollout=nil)
    if rollout && rollout.is_a?(Rollout)
      @rollout = rollout
    end
  end

  def rollout?
    !! @rollout
  end
  
  def redis
    @redis ||= if rollout?
      @rollout.instance_variable_get(:@redis)
    else
      FauxRedis.new 
    end
  end

  def active?(feature, user=nil)
    if environment_active?(feature) && rollout? && user
      @rollout.active?(feature, user)
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
    @rollout.activate_group(feature, group)
    feature_set_add(feature)
  end

  def activate_user(feature, user)
    @rollout.activate_user(feature, user)
    feature_set_add(feature)
  end

  def cleanup_feature_set!
    features_rollout.each do |feature|
      unused_feature = { :percentage => 0, :groups => [], :users => [] }
      feature_set_del(feature) if (@source.info(feature) == unused_feature)
    end
  end

  def method_missing(meth, *args, &block)
    if rollout?
      @rollout.send(meth, *args, &block)
      cleanup_feature_set! if (meth =~ /(:de)?activate/)
    else
      super
    end
  end

  private

  def environment_key_pattern
    /^FEATURE_(.*)$/
  end

  def environment_key(feature)
    ("FEATURE_%s" % feature).upcase
  end

  def environment_active?(feature)
    ENV[environment_key(feature)] == '1'
  end

  def feature_set_purge
    redis.del(feature_set_key)
  end

  def feature_set_del(feature)
    redis.srem(feature_set_key, feature)
  end

  def feature_set_add(feature)
    redis.sadd(feature_set_key, feature)
  end

  def feature_set_key
    'features'
  end


  # Set of all feature keys
  def features
    features_environment + features_rollout
  end
  
  def features_rollout
    redis.smembers(feature_set_key).to_set
  end

  def features_environment
    ENV.keys.reduce([]) do |a,k| 
      if (k =~ environment_key_pattern)
        a << $1
      end
    end.to_set
  end
end
