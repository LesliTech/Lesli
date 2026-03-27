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

            def invoke_model_generator
                invoke "lesli:model", [name, *attributes]
            end

            # Invokes the custom Lesli controller generator.
            def invoke_controller_generator
                invoke "lesli:controller", [name, *attributes]
            end

            # Invokes the custom Lesli service generator.
            def invoke_service_generator
                invoke "lesli:service", [name, *attributes]
            end

            def invoke_views_generator
                invoke "lesli:views", [name, *attributes]
            end

            def invoke_migration_generator
                invoke "active_record:migration", [migration_name, *attributes]
            end

            def invoke_route_generator
                invoke "resource_route", [resource_collection_name]
            end

            private

            def migration_name
                "create_#{engine_name}_#{resource_collection_name}"
            end
        end
    end
end
