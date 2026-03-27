# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
    module Generators
        # Generates a Lesli-style service object inside the current engine.
        class ServiceGenerator < BaseGenerator
            argument :attributes, type: :array, default: [], banner: "field:type field:type"

            source_root File.expand_path("templates", __dir__)

            # Creates the service file from the template.
            def create_service_file
                template "service.rb.tt", service_file_path
            end

            private

            # Returns the service directory inside the engine namespace.
            #
            # Example:
            #   app/services/lesli_support
            #   app/services/my_engine
            #   app/services/store
            def service_directory
                File.join(ENGINE_ROOT, "app/services", engine_name)
            end

            # Returns the final service file path.
            #
            # Example:
            #   app/services/lesli_support/ticket_service.rb
            def service_file_path
                File.join(service_directory, "#{resource_name}_service.rb")
            end
        end
    end
end
