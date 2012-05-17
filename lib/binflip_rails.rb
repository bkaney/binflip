#
# A view helper so:
#
#   <body data-features=<% binflip_features(current_user) %>>
#
#   %body{'data-features' => binflip_features(current_user)}
#
#
module BinflipRails
  if defined?(Rails) && defined?(Rails::Engine)
    class Engine < Rails::Engine
    end

    module ViewHelpers
      def active_features(user=nil, binflip=$binflip)
        binflip.active_features(user).to_json
      end
    end

    module Rails
      class Railtie < ::Rails::Railtie
        view_helpers do

        end
      end
    end
  end
end
