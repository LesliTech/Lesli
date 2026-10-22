# test/models/lesli_account_test.rb
require "test_helper"

module Lesli
    class AccountTest < LesliTesting::ModelTester
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
            assert_not_empty engine_account_tables

            engine_account_tables.each do |table_name|
                index = database_connection
                    .indexes(table_name)
                    .find { |candidate| candidate.columns == ["account_id"] }

                assert_not_nil index, table_name
                assert index.unique, table_name
            end
        end

        test "engine resources reference their local account table" do
            assert_not_empty engine_account_tables

            engine_account_tables.each do |account_table|
                engine_resource_tables(account_table).each do |resource_table|
                    foreign_key = account_foreign_key(resource_table)

                    assert_not_nil foreign_key, resource_table
                    assert_equal account_table, foreign_key.to_table, resource_table
                end
            end
        end

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

            assert_raises ActiveRecord::RecordNotUnique do
                account.save!(validate: false)
            end
        end

        test "region defaults to america" do
            account = Lesli::Account.new(
                status: "active",
                email: "new-account@example.com"
            )

            assert_equal "america", account.region
        end

        private

        def engine_account_tables
            database_connection.tables.select do |table_name|
                next false unless table_name.end_with?("_accounts")
                next false if table_name == Lesli::Account.table_name

                account_foreign_key(table_name)&.to_table == Lesli::Account.table_name
            end
        end

        def engine_resource_tables(account_table)
            table_prefix = account_table.delete_suffix("_accounts")

            database_connection.tables.select do |table_name|
                table_name.start_with?("#{table_prefix}_") &&
                    table_name != account_table &&
                    database_connection.column_exists?(table_name, :account_id)
            end
        end

        def account_foreign_key(table_name)
            database_connection.foreign_keys(table_name).find do |foreign_key|
                foreign_key.options[:column].to_s == "account_id"
            end
        end

        def database_connection
            ActiveRecord::Base.connection
        end
    end
end
