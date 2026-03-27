# frozen_string_literal: true

require "rails/generators"

module Lesli
  module Generators
    # Shared base generator for all Lesli generators.
    #
    # This class centralizes the logic used by all generators, such as:
    #
    # - engine name detection
    # - engine namespace detection
    # - domain name normalization
    # - resource naming helpers
    #
    # This avoids duplicating the same helper methods in every generator.
    class BaseGenerator < Rails::Generators::NamedBase

      private

      # Returns the current engine folder name in snake_case.
      #
      # Examples:
      #   "/code/lesli_support" -> "lesli_support"
      #   "/code/my_engine"     -> "my_engine"
      #   "/code/store"         -> "store"
      def engine_name
        File.basename(ENGINE_ROOT.to_s).underscore
      end

      # Returns the current engine Ruby namespace in CamelCase.
      #
      # Examples:
      #   "lesli_support" -> "LesliSupport"
      #   "my_engine"     -> "MyEngine"
      #   "store"         -> "Store"
      def engine_namespace
        engine_name.camelize
      end

      # Returns the domain name derived from the engine namespace.
      #
      # Rules:
      # - If the engine starts with "Lesli", remove that prefix
      # - Otherwise use the full engine namespace
      # - Convert the result to snake_case
      #
      # Examples:
      #   "LesliSupport"  -> "support"
      #   "LesliCalendar" -> "calendar"
      #   "MyEngine"      -> "my_engine"
      #   "Store"         -> "store"
      def engine_domain_name
        namespace = engine_namespace

        if namespace.start_with?("Lesli") && namespace != "Lesli"
          namespace.delete_prefix("Lesli").underscore
        else
          namespace.underscore
        end
      end

      # Returns the singular normalized resource name.
      #
      # Examples:
      #   "tickets"  -> "ticket"
      #   "products" -> "product"
      #   "store"    -> "store"
      #
      # This is the main workaround for NamedBase, because by default
      # a plural input like "products" may produce class_name = "Products".
      def resource_name
        name.to_s.singularize.underscore
      end

      # Returns the plural normalized resource name.
      #
      # Examples:
      #   "ticket"  -> "tickets"
      #   "product" -> "products"
      def resource_collection_name
        resource_name.pluralize
      end

      # Returns the Ruby model class name.
      #
      # Examples:
      #   "ticket"  -> "Ticket"
      #   "product" -> "Product"
      def resource_class_name
        resource_name.camelize
      end

      # Returns the plural controller class name.
      #
      # Examples:
      #   "tickets"  -> "Tickets"
      #   "products" -> "Products"
      def controller_class_name
        resource_collection_name.camelize
      end

      # Returns the service class name.
      #
      # Examples:
      #   "Ticket"  -> "TicketService"
      #   "Product" -> "ProductService"
      def service_class_name
        "#{resource_class_name}Service"
      end

      # Returns the resource instance variable name.
      #
      # Examples:
      #   "ticket"  -> "@ticket"
      #   "product" -> "@product"
      def resource_instance
        "@#{resource_name}"
      end

      # Returns the resource collection instance variable name.
      #
      # Examples:
      #   "tickets"  -> "@tickets"
      #   "products" -> "@products"
      def resource_collection_instance
        "@#{resource_collection_name}"
      end

      # Returns the before_action setter method name.
      #
      # Examples:
      #   "ticket"  -> "set_ticket"
      #   "product" -> "set_product"
      def set_resource_method_name
        "set_#{resource_name}"
      end

      # Returns the params method name.
      #
      # Examples:
      #   "ticket"  -> "ticket_params"
      #   "product" -> "product_params"
      def params_method_name
        "#{resource_name}_params"
      end

      # Returns the namespaced model class name.
      #
      # Examples:
      #   "LesliSupport::Ticket"
      #   "MyEngine::Product"
      def namespaced_resource_class_name
        "#{engine_namespace}::#{resource_class_name}"
      end

      # Returns only the attribute names passed to the generator.
      #
      # Example:
      #   ["subject:string", "owner_id:integer"] -> ["subject", "owner_id"]
      def permitted_attributes
        return [] unless respond_to?(:attributes)

        attributes.map(&:name)
      end
    end
  end
end
