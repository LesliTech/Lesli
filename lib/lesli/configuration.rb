module Lesli
    
    def self.configure(&block)
        @config ||= Lesli::Engine::Configuration.new

        yield @config if block

        @config
    end

    def self.config
        Rails.application.config
    end

end
