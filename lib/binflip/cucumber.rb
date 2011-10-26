require 'binflip'

module Binflip
  module Cucumber
    
    def self.toggle_bin!(current_bin, scenario)
      # Toggle bin
      Binflip.module_eval <<-RUBY
        def self.current_bin
          return '#{current_bin}'
        end
      RUBY

      # Toggle RAILS_ENV
      ENV["RAILS_ENV"] = Rails.env = "cucumber_#{current_bin}"
      ActiveRecord::Base.configurations = Rails.application.config.database_configuration
      ActiveRecord::Base.establish_connection


      # Reload routes
      reload_routes_if_new_bin(scenario)
    end
        
    def self.current_tags(scenario) 
      [ scenario.instance_variable_get(:@tags).tag_names + 
        scenario.instance_variable_get(:@feature).instance_variable_get(:@tags).tag_names 
      ].flatten
    end

    def self.rails_app
      raise NotImplementedError
    end

    def self.reload_routes_if_new_bin(scenario)
      if current_tags(scenario) != $tags
        rails_app.reload_routes!
      end
    end

  end
end

Before do |scenario|
  tags = Binflip::Cucumber.current_tags(scenario)

  if tags.size <= 1
    bin = tags.first.try(:gsub, '@', '')
    bin = bin.nil? ? Binflip::DEPLOYED_BIN : bin
    Binflip::Cucumber.toggle_bin!(bin, scenario)
  end

end

After do |scenario|
  $tags = Binflip::Cucumber.current_tags(scenario)
end
