# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
    module Generators
        # Generates a Lesli-style model inside the current engine.
        #
        # Example:
        #   rails generate lesli:model tickets
        #
        # Result:
        #   app/models/lesli_support/ticket.rb
        class ModelGenerator < BaseGenerator
            argument :attributes, type: :array, default: [], banner: "field:type field:type"

            source_root File.expand_path("templates", __dir__)

            # Creates the model file from the template.
            def create_model_file
                template "model.rb.tt", model_file_path
            end

            private

            # Returns the directory where the model file should be created.
            #
            # Example:
            #   app/models/lesli_support
            def model_directory
                File.join(ENGINE_ROOT, "app/models", engine_name)
            end

            # Returns the final path of the generated model file.
            #
            # Example:
            #   app/models/lesli_support/ticket.rb
            def model_file_path
                File.join(model_directory, "#{resource_name}.rb")
            end
        end
    end
end
