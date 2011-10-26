# in config/bin_flip.rb
#
#   $kanban = BinFlip.new
# 
# Now you can use toggle like so:
#
#   if $kanban.active?('235_feature_x')
#     # ...
#   end
#
module Binflip

  BINS = %w(dev approval sqa production)
  DEPLOYED_BIN = 'production'

  CONFIG_FILE = File.join(Rails.root, 'config', 'kanban.yml')
  
  class FeatureUnknown < Exception; end;
  class BinUnknown < Exception; end;
    
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
      @features ||= YAML.load_file(FEATURE_CONFIG_FILE)
    end
   
    def features_per_bin(bin)
      unless features.keys.include?(bin)
        raise BinUnknown, "It looks like you don't have a bin '#{bin}'" 
      end
      
      features[bin] || {}
    end

    def features=(features)
      @features = features
    end

  end

end

require 'core_ext/rake'
require 'lib/vendor/rails' if defined?(Rails)
