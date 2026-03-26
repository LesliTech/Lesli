# frozen_string_literal: true

require "rails/generators"
require "rails/generators/rails/scaffold/scaffold_generator"

module Lesli
    module Generators
        class ScaffoldGenerator < Rails::Generators::ScaffoldGenerator
            source_root File.expand_path("templates", __dir__)

            def create_service_file
                pp "works"
                #template "service.rb.tt", File.join("app/services", "#{singular_name}_service.rb")
            end
        end
    end
end
