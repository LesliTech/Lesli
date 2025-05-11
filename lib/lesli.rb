require "lesli/configuration"
require "lesli/routing"
require "lesli/version"
require "lesli/engine"
require "lesli/r_spec"

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
