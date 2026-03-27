# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
  module Generators
    # Generates a Lesli-style controller inside the current engine.
    class ControllerGenerator < BaseGenerator
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      source_root File.expand_path("templates", __dir__)

      # Creates the controller file from the template.
      def create_controller_file
        template "controller.rb.tt", controller_file_path
      end

      private

      # Returns the controller directory inside the engine namespace.
      #
      # Example:
      #   app/controllers/lesli_support
      #   app/controllers/my_engine
      #   app/controllers/store
      def controller_directory
        File.join(ENGINE_ROOT, "app/controllers", engine_name)
      end

      # Returns the final controller file path.
      #
      # Example:
      #   app/controllers/lesli_support/tickets_controller.rb
      def controller_file_path
        File.join(controller_directory, "#{resource_collection_name}_controller.rb")
      end
    end
  end
end
