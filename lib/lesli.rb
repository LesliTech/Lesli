require "lesli/configuration"
require "lesli/routing"
require "lesli/version"
require "lesli/courier"
require "lesli/engine"


module Lesli
    class << self
        attr_writer :config

        def config
            @config ||= Configuration.new
        end

        def configure
            yield(config)
        end
    end
end
