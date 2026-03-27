# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
  module Generators
    # Main Lesli scaffold generator.
    #
    # This generator delegates work to the specialized generators.
    class ScaffoldGenerator < BaseGenerator
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      # Invokes the custom Lesli controller generator.
      def invoke_controller_generator
        invoke "lesli:controller", [name, *attributes]
      end

      # Invokes the custom Lesli service generator.
      def invoke_service_generator
        invoke "lesli:service", [name, *attributes]
      end
    end
  end
end
