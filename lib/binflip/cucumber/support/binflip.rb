# In support.rb --
#
#     require 'bin_flip/cucumber'
#     BinFilp::Cucumber.rails_app = MyRailsApp::Application
Before do |scenario|
  tags = current_tags(scenario)

  if tags.size <= 1
    bin = tags.first.try(:gsub, '@', '')
    bin = bin.nil? ? BinFlip::DEPLOYED_BIN : bin
    BinFlip::Cucumber.toggle_bin!(bin, scenario)
  end

end

After do |scenario|
  $tags = current_tags(scenario)
end

