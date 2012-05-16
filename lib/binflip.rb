require 'delegate'

class Binflip

  if defined?(Rails) && defined?(Rails::Engine)
    class Engine < ::Rails::Engine
      require 'binflip/engine'
    end
  end


  def self.rollout?
    defined?(Rollout) == 'constant'
  end

  def initialize(redis=nil)
    if Binflip.rollout?
      @source = SimpleDelegator.new(Rollout.new(redis))
    end
  end

  def active?(feature, user=nil)
    if environment_active?(feature) && @source
      @source.active?(feature, user)
    else
      environment_active?(feature)
    end
  end

  def method_missing(meth, *args, &block)
    if @source
      @source.send(meth, *args, &block)
    else
      super
    end
  end

  private

  def environment_key(feature)
    ("FEATURE_%s" % feature).upcase
  end

  def environment_active?(feature)
    ENV[environment_key(feature)] == '1'
  end
end
