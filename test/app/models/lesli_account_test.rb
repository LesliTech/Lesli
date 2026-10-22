# test/models/lesli_account_test.rb
require "test_helper"

module Lesli
    class AccountTest < LesliTesting::ModelTester
        ENGINE_ACCOUNT_CLASS_NAMES = %w[
            LesliAdmin::Account
            LesliAudit::Account
            LesliBell::Account
            LesliCalendar::Account
            LesliContacts::Account
            LesliDashboard::Account
            LesliMailer::Account
            LesliShield::Account
            LesliSupport::Account
        ].freeze

        fixtures :lesli_accounts
        set_fixture_class lesli_accounts: "Lesli::Account" 

        test "fixture is valid" do
            assert lesli_accounts(:one).valid?
        end

        test "declares its LesliAudit account association" do
            audit = Lesli::Account.reflect_on_association(:audit)

            assert_equal "LesliAudit::Account", audit.class_name
            assert_equal :account_id, audit.options[:foreign_key]
            assert_equal :account, audit.options[:inverse_of]
        end

        test "declares engine accounts as one-to-one extensions" do
            {
                bell: "LesliBell::Account",
                admin: "LesliAdmin::Account",
                shield: "LesliShield::Account",
                mailer: "LesliMailer::Account",
                support: "LesliSupport::Account",
                contacts: "LesliContacts::Account",
                calendar: "LesliCalendar::Account",
                dashboard: "LesliDashboard::Account"
            }.each do |name, class_name|
                association = Lesli::Account.reflect_on_association(name)

                assert_equal :has_one, association.macro
                assert_equal class_name, association.class_name
                assert_equal :account_id, association.options[:foreign_key]
                assert_equal :account, association.options[:inverse_of]
            end
        end

        test "engine account tables enforce one workspace per core account" do
            engine_account_models.each do |model|
                index = ActiveRecord::Base.connection
                    .indexes(model.table_name)
                    .find { |candidate| candidate.columns == ["account_id"] }

                assert_not_nil index, model.name
                assert index.unique, model.name
            end
        end

        test "account associations match their database foreign keys" do
            connection = ActiveRecord::Base.connection

            loaded_application_models.each do |model|
                reflection = model.reflect_on_association(:account)
                next unless reflection
                next unless connection.data_source_exists?(model.table_name)

                foreign_key = connection.foreign_keys(model.table_name).find do |candidate|
                    candidate.options[:column].to_s == reflection.foreign_key.to_s
                end
                next unless foreign_key

                assert_equal(
                    reflection.klass.table_name,
                    foreign_key.to_table,
                    model.name
                )
            end
        end

        # --- Presence validations (recommended) ---
        test "requires status" do
            account = lesli_accounts(:one).dup
            account.status = nil
            assert_not account.valid?
            assert_includes account.errors[:status], "can't be blank"
        end

        test "requires email (db constraint)" do
        account = lesli_accounts(:one).dup
        account.email = nil

        assert_raises(ActiveRecord::NotNullViolation) do
            account.save!(validate: false)
        end
        end

        test "email is unique (db index)" do
            account = lesli_accounts(:one).dup
            account.status = "active"
            account.name = "Unique Name"

            # Hit the DB unique index directly (even if you don't have validates_uniqueness_of)
            assert_raises ActiveRecord::RecordNotUnique do
            account.save!(validate: false)
            end
        end

        test "region defaults to america" do
            account = Lesli::Account.new(
            status: "active",
            email: "new-account@example.com"
            # region omitted on purpose
            )

            assert_equal "america", account.region
        end

        private

        def engine_account_models
            ENGINE_ACCOUNT_CLASS_NAMES.filter_map do |class_name|
                model = class_name.safe_constantize
                next unless application_model?(model)
                next unless ActiveRecord::Base.connection.data_source_exists?(
                    model.table_name
                )

                model
            end
        end

        def loaded_application_models
            ApplicationRecord.descendants.reject(&:abstract_class?)
        end

        def application_model?(model)
            model.is_a?(Class) && model < ApplicationRecord
        end
    end
end
