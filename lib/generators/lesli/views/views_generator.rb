# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
    module Generators
        # Generates Lesli-style views for a resource inside the current engine.
        #
        # Example:
        #   rails generate lesli:views tickets subject:string description:text owner_id:integer
        #
        # Result:
        #   app/views/lesli_support/tickets/
        #     _form.html.erb
        #     index.html.erb
        #     show.html.erb
        #     new.html.erb
        #     edit.html.erb
        class ViewsGenerator < BaseGenerator
            argument :attributes, type: :array, default: [], banner: "field:type field:type"

            source_root File.expand_path("templates", __dir__)

            # Creates the views directory if it does not exist.
            def create_views_directory
                empty_directory views_directory
            end

            # Generates the shared form partial.
            def create_form_partial
                template "_form.html.erb.tt", File.join(views_directory, "_form.html.erb")
            end

            # Generates the index view.
            def create_index_view
                template "index.html.erb.tt", File.join(views_directory, "index.html.erb")
            end

            # Generates the show view.
            def create_show_view
                template "show.html.erb.tt", File.join(views_directory, "show.html.erb")
            end

            # Generates the new view.
            def create_new_view
                template "new.html.erb.tt", File.join(views_directory, "new.html.erb")
            end

            private

            # Returns the target views directory for the current resource.
            #
            # Example:
            #   app/views/lesli_support/tickets
            def views_directory
                File.join(ENGINE_ROOT, "app/views", engine_name, resource_collection_name)
            end

            # Returns only scalar-like attributes that can be rendered
            # as regular text inputs by default.
            def form_attributes
                permitted_attributes.reject do |attribute|
                    attribute.end_with?("_id") || attribute == "id"
                end
            end

            # Returns attributes that look like foreign keys.
            #
            # Example:
            #   owner_id, category_id, priority_id
            #
            # These are rendered as generic select controls.
            def select_attributes
                permitted_attributes.select { |attribute| attribute.end_with?("_id") }
            end

            # Returns the default columns used for the index table.
            #
            # We prefer to include uid first when it exists.
            def index_columns
                columns = []

                if permitted_attributes.include?("uid")
                    columns << { label: "ID", field: "uid" }
                end

                form_attributes.each do |attribute|
                    columns << {
                        label: attribute.humanize,
                        field: attribute
                    }
                end

                select_attributes.each do |attribute|
                    columns << {
                        label: attribute.delete_suffix("_id").humanize,
                        field: attribute
                    }
                end

                columns
            end
        end
    end
end
