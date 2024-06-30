

# · 
require "#{Lesli::Engine.root}/lib/generators/application_lesli_generator.rb"

module Lesli
    class SpecGenerator < ApplicationLesliGenerator
        source_root File.expand_path("templates", __dir__)
        def generator
            L2.msg "Generating Lesli Model spec"

            pp @info;
            pp "---     ---     ---     ---     ---     ---"
            pp @model;
            pp "---     ---     ---     ---     ---     ---"
            pp @services;
            pp "---     ---     ---     ---     ---     ---"
            pp @rspec;

            template("spec-model.template", "#{(@info[:engine].constantize)::Engine.root.join('spec', 'models', @info[:resource_code])}_spec.rb")
        end
    end
end
