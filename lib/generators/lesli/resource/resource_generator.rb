# frozen_string_literal: true

require "rails/generators"
require_relative "../base_generator"

module Lesli
    module Generators
        # Generates a complete account-scoped Lesli resource inside an engine.
        class ResourceGenerator < BaseGenerator
            ALLOWED_ITEMS = %w[activities attachments discussions tasks].freeze

            desc "Generate a complete account-scoped resource inside a Lesli engine"

            argument :attributes,
                type: :array,
                default: [],
                banner: "field:type field:type"

            class_option :skip_operator,
                type: :boolean,
                default: false,
                desc: "Do not generate the resource operator"

            class_option :skip_views,
                type: :boolean,
                default: false,
                desc: "Do not generate HTML views"

            class_option :skip_tests,
                type: :boolean,
                default: false,
                desc: "Do not generate tests"

            class_option :items,
                type: :array,
                default: [],
                desc: "Shared items to enable: activities attachments discussions tasks"

            class_option :migration_namespace,
                type: :numeric,
                desc: "Two-digit Lesli migration feature namespace"

            source_root File.expand_path("templates", __dir__)

            def validate_engine
                raise Thor::Error, "Missing engine account model: #{account_model_path}" unless account_model_path.file?
                raise Thor::Error, "Missing engine routes file: #{routes_path}" unless routes_path.file?

                unsupported_items = selected_items - ALLOWED_ITEMS
                raise Thor::Error, "Unsupported Lesli items: #{unsupported_items.join(', ')}" if unsupported_items.any?

                conflicting_migration = migration_with_same_version
                return unless conflicting_migration

                raise Thor::Error, <<~MESSAGE.squish
                    Migration version #{migration_version} already belongs to
                    #{conflicting_migration.basename}. Choose another --migration-namespace.
                MESSAGE
            end

            def create_model
                template "model.rb.tt", model_path
            end

            def create_migration
                template "migration.rb.tt", migration_path
            end

            def create_service
                template "service.rb.tt", service_path
            end

            def create_operator
                return if options[:skip_operator]

                template "operator.rb.tt", operator_path
            end

            def create_controller
                template "controller.rb.tt", controller_path
            end

            def create_views
                return if options[:skip_views]

                template "views/_form.html.erb.tt", views_path.join("_form.html.erb")
                template "views/index.html.erb.tt", views_path.join("index.html.erb")
                template "views/show.html.erb.tt", views_path.join("show.html.erb")
                template "views/new.html.erb.tt", views_path.join("new.html.erb")
                template "views/edit.html.erb.tt", views_path.join("edit.html.erb")
            end

            def create_locale
                template "locale.en.yml.tt", locale_path
            end

            def create_tests
                return if options[:skip_tests]

                template "tests/model_test.rb.tt", model_test_path
                template "tests/service_test.rb.tt", service_test_path
                template "tests/controller_test.rb.tt", controller_test_path
                template "tests/operator_test.rb.tt", operator_test_path unless options[:skip_operator]
            end

            def add_account_association
                association = <<~RUBY.indent(8)
                    has_many :#{resource_collection_name},
                        class_name: "#{namespaced_resource_class_name}",
                        foreign_key: :account_id,
                        dependent: :destroy
                RUBY

                update_class_file(account_model_path, "Account", association, "has_many :#{resource_collection_name}")
            end

            def add_resource_route
                route = "    resources :#{resource_collection_name}\n"
                update_routes_file(route)
            end

            private

            def update_class_file(path, class_name, content, marker)
                existing_content = path.read
                return if behavior != :revoke && existing_content.include?(marker)

                inject_into_class path, class_name, content
            end

            def update_routes_file(route)
                existing_content = routes_path.read
                return if behavior != :revoke && existing_content.include?(route.strip)

                inject_into_file routes_path, route, after: /routes\.draw do\s*\n/
            end

            def model_path
                engine_root.join("app/models", engine_name, "#{resource_name}.rb")
            end

            def service_path
                engine_root.join("app/services", engine_name, "#{resource_name}_service.rb")
            end

            def operator_path
                engine_root.join("app/operators", engine_name, "#{resource_name}_operator.rb")
            end

            def controller_path
                engine_root.join("app/controllers", engine_name, "#{resource_collection_name}_controller.rb")
            end

            def views_path
                engine_root.join("app/views", engine_name, resource_collection_name)
            end

            def locale_path
                engine_root.join("config/locales", "#{engine_name}.#{resource_name}.en.yml")
            end

            def model_test_path
                engine_root.join("test/models", engine_name, "#{resource_name}_test.rb")
            end

            def service_test_path
                engine_root.join("test/services", engine_name, "#{resource_name}_service_test.rb")
            end

            def operator_test_path
                engine_root.join("test/operators", engine_name, "#{resource_name}_operator_test.rb")
            end

            def controller_test_path
                engine_root.join("test/controllers", engine_name, "#{resource_collection_name}_controller_test.rb")
            end

            def migration_path
                existing_resource_migration ||
                    migration_directory.join("#{migration_version}_create_#{table_name}.rb")
            end

            def existing_resource_migration
                @existing_resource_migration ||= begin
                    pattern = engine_root.join("db/migrate/**/*_create_#{table_name}.rb")
                    path = Dir[pattern.to_s].sort.first
                    Pathname.new(path) if path
                end
            end

            def migration_directory
                account_migration_path.dirname
            end

            def account_migration_path
                @account_migration_path ||= begin
                    pattern = engine_root.join("db/migrate/**/*_create_#{account_table_name}.rb")
                    path = Dir[pattern.to_s].sort.find do |candidate|
                        File.basename(candidate).match?(/\A\d{10}_/)
                    end

                    raise Thor::Error, "Could not find the versioned #{account_table_name} migration" unless path

                    Pathname.new(path)
                end
            end

            def migration_version
                @migration_version ||= begin
                    return existing_resource_migration.basename.to_s.first(10) if existing_resource_migration

                    "#{engine_migration_prefix}#{migration_namespace_code}0110"
                end
            end

            def migration_with_same_version
                pattern = engine_root.join("db/migrate/**/#{migration_version}_*.rb")

                Dir[pattern.to_s].map { |path| Pathname.new(path) }.find do |path|
                    path != existing_resource_migration
                end
            end

            def engine_migration_prefix
                account_migration_path.basename.to_s.first(4)
            end

            def migration_namespace_code
                namespace = options[:migration_namespace]&.to_i
                namespace ||= next_migration_namespace

                unless namespace.between?(1, 99)
                    raise Thor::Error, "Migration namespace must be between 1 and 99"
                end

                namespace.to_s.rjust(2, "0")
            end

            def next_migration_namespace
                pattern = engine_root.join("db/migrate/**/*.rb")
                namespaces = Dir[pattern.to_s].filter_map do |path|
                    version = File.basename(path)[/\A\d{10}/]
                    next unless version&.start_with?(engine_migration_prefix)

                    version[4, 2].to_i
                end

                [namespaces.max.to_i + 1, 1].max
            end

            def migration_class_name
                "Create#{engine_name.camelize}#{resource_collection_name.camelize}"
            end

            def database_attributes
                attributes.reject do |attribute|
                    attribute.virtual? || %w[account account_id deleted_at created_at updated_at].include?(attribute.name)
                end
            end

            def selected_items
                @selected_items ||= Array(options[:items]).map(&:to_s).map(&:downcase).uniq.sort
            end

            def item_enabled?(name)
                selected_items.include?(name.to_s)
            end

            def form_attributes
                attributes.reject { |attribute| attribute.name == "id" }
            end

            def index_attributes
                form_attributes.reject(&:virtual?)
            end

            def operator_class_name
                "#{resource_class_name}Operator"
            end

            def valid_attribute_pairs
                attributes.filter_map do |attribute|
                    next if attribute.reference? || attribute.virtual?

                    [attribute.column_name, attribute.default]
                end
            end
        end
    end
end
