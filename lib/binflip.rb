# in config/binflip.rb
#
#   $kanban = BinFlip.new
# 
# Now you can use toggle like so:
#
#   if $kanban.active?('235_feature_x')
#     # ...
#   end

module Binflip

  BINS = %w(development approval sqa production)
  DEPLOYED_BIN = 'production'

  class FeatureUnknown < Exception; end;
  class BinUnknown < Exception; end;
  
  def self.config_file
    raise NotImplementedError
  end

  def self.current_bin
    raise NotImplementedError
  end

  class << self

    def active?(feature)
      unless features_per_bin(self.current_bin).keys.include?(feature.to_s)
        raise FeatureUnknown, "It looks like you may have forgot to remove toggle code for '#{feature}'."
      end

      features_per_bin(current_bin)[feature.to_s]
    end

    def features
      @features ||= YAML.load_file(self.config_file)
    end

    def features_per_bin(bin)
      unless features.keys.include?(bin.to_s)
        raise BinUnknown, "It looks like you don't have a bin '#{bin}'" 
      end

      features[bin.to_s] || {}
    end

    def features=(features)
      @features = features
    end

  end

end

require 'core_ext/rake'
require 'binflip/rails' if defined?(Rails)
