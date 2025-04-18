

# · 
require "#{Lesli::Engine.root}/lib/generators/application_lesli_generator_base.rb"

module Lesli
    class SpecGenerator < ApplicationLesliGeneratorBase
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

            #template("spec-factory.template", "#{(@info[:engine].constantize)::Engine.root.join('spec', 'factories', @info[:engine_resource_code])}.rb")
            template("spec-model.template", "#{(@info[:engine].constantize)::Engine.root.join('spec', 'models', @info[:engine_resource_code])}_spec.rb")
        end
    end
end
