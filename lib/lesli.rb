require "lesli/configuration"
require "lesli/version"
require "lesli/courier"
require "lesli/engine"
require "lesli/router"


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
