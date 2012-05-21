module BinflipRails
  if defined?(Rails) && defined?(Rails::Engine)
    class Engine < Rails::Engine
    end
  end
end
