require "test_helper"
require "generators/lesli/resource/resource_generator"
require "ripper"

module Lesli
    module Generators
        class ResourceGeneratorTest < Rails::Generators::TestCase
            tests ResourceGenerator
            destination Rails.root.join("tmp/generators/lesli_support")

            setup do
                prepare_destination
                prepare_engine
            end

            test "generates a complete account-scoped resource" do
                run_generator generator_arguments(
                    "ticket",
                    "subject:string",
                    "description:text",
                    "--items=activities",
                    "tasks"
                )

                assert_file "app/models/lesli_support/ticket.rb", /belongs_to :account/
                assert_file "app/models/lesli_support/ticket.rb", /include Lesli::Items::Activities/
                assert_file "app/services/lesli_support/ticket_service.rb", /def destroy/
                assert_file "app/operators/lesli_support/ticket_operator.rb", /class TicketOperator/
                assert_file "app/controllers/lesli_support/tickets_controller.rb", /def create/
                assert_file "app/views/lesli_support/tickets/_form.html.erb"
                assert_file "app/views/lesli_support/tickets/edit.html.erb"
                assert_file "config/locales/lesli_support.ticket.en.yml"
                assert_file "test/models/lesli_support/ticket_test.rb"
                assert_file "test/services/lesli_support/ticket_service_test.rb"
                assert_file "test/operators/lesli_support/ticket_operator_test.rb"
                assert_file "test/controllers/lesli_support/tickets_controller_test.rb"

                assert_file "db/migrate/v1/0702110110_create_lesli_support_tickets.rb" do |migration|
                    assert_match(/t\.string :subject/, migration)
                    assert_match(/t\.text :description/, migration)
                    assert_match(/to_table: :lesli_support_accounts/, migration)
                end

                assert_file "app/models/lesli_support/account.rb", /has_many :tickets/
                assert_file "config/routes.rb", /resources :tickets/

                generated_ruby_files.each do |path|
                    assert Ripper.sexp(path.read), "Expected #{path} to contain valid Ruby syntax"
                end
            end

            test "supports a minimal API-style resource" do
                run_generator generator_arguments(
                    "event",
                    "name:string",
                    "--skip-operator",
                    "--skip-views",
                    "--skip-tests",
                    "--migration-namespace=12"
                )

                assert_file "app/models/lesli_support/event.rb"
                assert_file "app/services/lesli_support/event_service.rb"
                assert_file "app/controllers/lesli_support/events_controller.rb"
                assert_file "db/migrate/v1/0702120110_create_lesli_support_events.rb"
                assert_no_file "app/operators/lesli_support/event_operator.rb"
                assert_no_directory "app/views/lesli_support/events"
                assert_no_file "test/models/lesli_support/event_test.rb"
            end

            test "supports resources owned directly by the core account" do
                core_root = destination_root.join("lesli")

                write_file(
                    "lesli/app/models/lesli/account.rb",
                    "module Lesli; class Account < ApplicationRecord; end; end\n"
                )
                write_file(
                    "lesli/config/routes.rb",
                    "Lesli::Engine.routes.draw do\nend\n"
                )
                write_file(
                    "lesli/db/migrate/v1/0000000110_create_lesli_accounts.rb",
                    "class CreateLesliAccounts < ActiveRecord::Migration[8.1]; end\n"
                )

                run_generator [
                    "note",
                    "title:string",
                    "--items=tasks",
                    "--migration-namespace=1",
                    "--engine-root=#{core_root}",
                    "--engine-namespace=Lesli"
                ]

                assert_file "lesli/app/models/lesli/note.rb", /account == user\.account/
                assert_file "lesli/app/services/lesli/note_service.rb", /current_user\.account\.notes/
                assert_file "lesli/db/migrate/v1/0000010110_create_lesli_notes.rb"
            end

            test "revokes only the generated resource structure" do
                arguments = generator_arguments(
                    "ticket",
                    "subject:string",
                    "--migration-namespace=11"
                )

                run_generator arguments
                run_generator arguments, behavior: :revoke

                assert_no_file "app/models/lesli_support/ticket.rb"
                assert_no_file "app/services/lesli_support/ticket_service.rb"
                assert_no_file "db/migrate/v1/0702110110_create_lesli_support_tickets.rb"
                assert_file "app/models/lesli_support/account.rb" do |account|
                    refute_match(/has_many :tickets/, account)
                end
                assert_file "config/routes.rb" do |routes|
                    refute_match(/resources :tickets/, routes)
                end
            end

            test "rejects a migration version owned by another resource" do
                write_file(
                    "db/migrate/v1/0702110110_create_lesli_support_messages.rb",
                    "class CreateLesliSupportMessages < ActiveRecord::Migration[8.1]; end\n"
                )

                run_generator generator_arguments(
                    "ticket",
                    "--migration-namespace=11"
                )

                assert_no_file "app/models/lesli_support/ticket.rb"
                assert_file "app/models/lesli_support/account.rb" do |account|
                    refute_match(/has_many :tickets/, account)
                end
                assert_file "config/routes.rb" do |routes|
                    refute_match(/resources :tickets/, routes)
                end
            end

            private

            def generator_arguments(*arguments)
                [
                    *arguments,
                    "--engine-root=#{destination_root}",
                    "--engine-namespace=LesliSupport"
                ]
            end

            def prepare_engine
                write_file(
                    "app/models/lesli_support/account.rb",
                    <<~RUBY
                        module LesliSupport
                            class Account < ApplicationRecord
                            end
                        end
                    RUBY
                )

                write_file(
                    "config/routes.rb",
                    <<~RUBY
                        LesliSupport::Engine.routes.draw do
                        end
                    RUBY
                )

                write_file(
                    "db/migrate/v1/0702000110_create_lesli_support_accounts.rb",
                    "class CreateLesliSupportAccounts < ActiveRecord::Migration[8.1]; end\n"
                )

                write_file(
                    "db/migrate/v1/0702100110_create_lesli_support_slas.rb",
                    "class CreateLesliSupportSlas < ActiveRecord::Migration[8.1]; end\n"
                )
            end

            def write_file(relative_path, contents)
                path = destination_root.join(relative_path)
                FileUtils.mkdir_p(path.dirname)
                File.write(path, contents)
            end

            def generated_ruby_files
                destination_root.glob("{app,config,db,test}/**/*.rb")
            end
        end
    end
end
