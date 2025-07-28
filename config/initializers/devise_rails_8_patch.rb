require 'devise'

module Devise
    def self.mappings
        Rails.application.try(:reload_routes_unless_loaded)
        @@mappings
    end
end
