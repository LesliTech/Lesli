require "test_helper"
require "rake"
require "lesli/database_tasks"

module DatabaseTasksFirstEngine
    class Engine
        class << self
            attr_accessor :events

            def load_seed
                events << :first_engine
            end
        end
    end
end

module DatabaseTasksSecondEngine
    class Engine
        class << self
            attr_accessor :events

            def load_seed
                events << :second_engine
            end
        end
    end
end

module Lesli
    class DatabaseTasksTest < ActiveSupport::TestCase
        class RecordingDatabaseTasks < DatabaseTasks
            attr_reader :events

            def initialize
                @events = []
            end

            private

            def reset_database
                events << :reset
            end

            def prepare_database
                events << :prepare
            end

            def seed_database
                events << :seed
            end

            def configure_database
                events << :configure
            end

            def print_status
                events << :status
            end
        end

        class RecordingConfigurationTasks < DatabaseTasks
            attr_reader :events

            def initialize
                @events = []
            end

            private

            def build_resources
                events << :resources
            end

            def initialize_accounts
                events << :accounts
            end

            def synchronize_privileges
                events << :privileges
            end

            def synchronize_translations
                events << :translations
            end
        end

        test "rebuild resets, seeds, configures, and reports status in order" do
            tasks = RecordingDatabaseTasks.new

            tasks.rebuild

            assert_equal [:reset, :seed, :configure, :status], tasks.events
        end

        test "build prepares, seeds, configures, and reports status in order" do
            tasks = RecordingDatabaseTasks.new

            tasks.build

            assert_equal [:prepare, :seed, :configure, :status], tasks.events
        end

        test "prepare does not load seeds" do
            tasks = RecordingDatabaseTasks.new

            tasks.prepare

            assert_equal [:prepare, :configure, :status], tasks.events
        end

        test "seed loads data before configuring accounts" do
            tasks = RecordingDatabaseTasks.new

            tasks.seed

            assert_equal [:seed, :configure, :status], tasks.events
        end

        test "configuration phases run in order" do
            tasks = RecordingConfigurationTasks.new

            with_singleton_method(Termline, :info, ->(_message) {}) do
                tasks.send(:configure_database)
            end

            assert_equal(
                [:resources, :accounts, :privileges, :translations],
                tasks.events
            )
        end

        test "seed loading runs engines before the host application" do
            events = []
            requested_tasks = []
            host_seed_task = Object.new
            host_seed_task.define_singleton_method(:invoke) do
                events << :host_application
            end

            DatabaseTasksFirstEngine::Engine.events = events
            DatabaseTasksSecondEngine::Engine.events = events

            engines = {
                "DatabaseTasksFirstEngine" => {},
                "Root" => {},
                "DatabaseTasksSecondEngine" => {}
            }

            task_lookup = lambda do |task_name|
                requested_tasks << task_name
                host_seed_task
            end

            info = lambda do |message|
                events << :host_message if message == "Loading seeds for: Main app"
            end

            with_singleton_method(LesliSystem, :engines, -> { engines }) do
                with_singleton_method(Rake::Task, :[], task_lookup) do
                    with_singleton_method(Termline, :info, info) do
                        with_singleton_method(Termline, :br, ->(_lines) {}) do
                            DatabaseTasks.new.send(:seed_database)
                        end
                    end
                end
            end

            assert_equal(
                [
                    :first_engine,
                    :second_engine,
                    :host_message,
                    :host_application
                ],
                events
            )
            assert_equal ["db:seed"], requested_tasks
        ensure
            DatabaseTasksFirstEngine::Engine.events = nil
            DatabaseTasksSecondEngine::Engine.events = nil
        end

        test "database preparation restores the Rails seed loader" do
            database_tasks = ActiveRecord::Tasks::DatabaseTasks
            original_seed_loader = database_tasks.seed_loader
            seed_loader_during_prepare = nil

            prepare_task = Object.new
            prepare_task.define_singleton_method(:invoke) do
                seed_loader_during_prepare = database_tasks.seed_loader
            end

            with_singleton_method(Rake::Task, :[], ->(_task_name) { prepare_task }) do
                with_singleton_method(Termline, :info, ->(_message) {}) do
                    DatabaseTasks.new.send(:prepare_database)
                end
            end

            refute_same original_seed_loader, seed_loader_during_prepare
            assert_respond_to seed_loader_during_prepare, :load_seed
            assert_same original_seed_loader, database_tasks.seed_loader
        end

        private

        def with_singleton_method(target, method_name, implementation)
            singleton_class = target.singleton_class
            visibility = singleton_method_visibility(singleton_class, method_name)
            original_method = singleton_class.instance_method(method_name) if visibility

            singleton_class.define_method(method_name, implementation)
            yield
        ensure
            singleton_class.remove_method(method_name)

            if original_method
                singleton_class.define_method(method_name, original_method)
                singleton_class.send(visibility, method_name)
            end
        end

        def singleton_method_visibility(singleton_class, method_name)
            return :public if singleton_class.public_instance_methods(false).include?(method_name)
            return :protected if singleton_class.protected_instance_methods(false).include?(method_name)
            return :private if singleton_class.private_instance_methods(false).include?(method_name)

            nil
        end
    end
end
