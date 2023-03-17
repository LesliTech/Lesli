=begin

Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
module Shared
    class Dashboard < ApplicationLesliRecord
        self.abstract_class = true

        belongs_to :user_creator, class_name: "User", foreign_key: "users_id", optional: true

        after_update :verify_default_dashboard
        after_create :verify_default_dashboard

        # @return [void]
        # @param account [LesliEngine::Account]
        # @description Initializes a default dummy dashboard for the account. This guarantees that the users
        #     will be able to access the dashboard page. Even if it's empty.
        # @example
        #     # Imagine you are adding a new engine to your instance (CloudProposal)
        #     # To execute this function, you must only do
        #     my_account = Account.first
        #     my_account.proposal = CloudProposal::Account.new
        def self.initialize_data(account)
            self.create!(
                account: account,
                name: "Default Dashboard",
                default: true,
                main: false
            )
        end

        # @return [Hash] Hash of containing the information of the dashboard and its components.
        # @description Returns a hash with information about the dashboard and all its *components*.
        #     Each component is returned in the configuration view, not the render view. This means that
        #     this method is ment to be used when updating the dashboard
        # @example
        #     respond_with_successful(CloudHelp::Dashboard.first.show)
        def show
            attributes.merge({
                components: components.order(index: :asc)
            })
        end

        # @return [Hash] A hash with a the **:dashboards** key that has all the dashboards for the engine
        # @param current_user [User] The user that made this request
        # @param query [Hash] Query containing filters. Currently unused, but required
        # @descriptions Retrieves and returns a list of all the dashboards in the engine. No information about the dashboard
        #     components is retrieved.
        # @example
        #     CloudHouse::Dashboard.list(User.first, nil)
        def self.list(current_user, query)
            dynamic_info = self.dynamic_info
            module_name = dynamic_info[:module_name]
            full_module_name = dynamic_info[:full_module_name].underscore

            # get search string from query params
            search_string = query[:search].downcase.gsub(" ","%") unless query[:search].blank?

            dashboards = self.where(
                "#{full_module_name}_accounts_id".to_sym => current_user.account.id
            ).order(ActiveRecord::Base.sanitize_sql_for_order("#{query[:order][:by]} #{query[:order][:dir]}"))

            # Filter results by search string
            unless search_string.blank?
                dashboards = dashboards.where("(LOWER(name) SIMILAR TO :search_string)", search_string: "%#{sanitize_sql_like(search_string)}%")
            end

            dashboards = dashboards.map do |dashboard|
                dashboard_attributes = dashboard.attributes

                dashboard_attributes["created_at"] = LC::Date.to_string_datetime(dashboard.created_at)
                dashboard_attributes
            end

            {
                dashboards: dashboards
            }
        end

        # @return [Hash] Hash containing the options to create and manage dashboards
        # @param current_user [User] The user that made this request
        # @param query [Hash] Query containing filters. Currently unused, but required
        # @descriptions Returns a list of options needed to create and manage dashboard components. For now,
        #     the returned options are: A list of roles, the enoun containing the component_ids, generic configuration options
        #     for all dashboad components and a descriptions hash, that contains brief descriptions for each component to help
        #     the user understand what each component does. Any class that inherits from this one can send a block to add extra
        #     functionality. For example, the descriptions must be implemented directly from the engine.
        # @example
        #         CloudHouse::Dashboard.options(User.find(2), nil)
        def self.options(current_user, query)
            dynamic_info = self.dynamic_info
            component_model = dynamic_info[:component_model]

            roles = current_user.account.roles.select(
                :id,
                :name
            ).order(
                name: :asc
            ).map do |role|
                {
                    value: role.id,
                    text: role.name
                }
            end

            component_ids = component_model.component_ids.map do |key, value|
                {
                    value: key,
                    text: value
                }
            end

            options = {
                roles: roles,
                component_ids: component_ids,
                components_configuration_options: component_model.configuration_options,
                descriptions: {}
            }

            if block_given?
                yield(options)
            else
                return options
            end
        end

        # @return [void]
        # @description Checks if the dasboard to be deleted is the default dashboard. If it is, prevents the destruction
        #     and returns an error message. If not, executes a normal destroy process
        # @example
        #     random_dashboard = CloudHouse::Dashboard.where(default: false).first
        #     random_dashboard.destroy! # This will be executed without problem
        #     default_dashboard = CloudHouse::Dashboard.find_by(default: true)
        #     default_dashboard.destroy! # this will throw an error
        def destroy
            if default
                errors.add(:base, :cannot_delete_default_dashboard)
                return false
            end

            super
        end

        private

        # @return [void]
        # @descriptions This is an after_updated and after_create method that validates that at any moment in time, there is only
        #     one default dashboard in the engine. If there is another default dashboard, it's *default* field is set to false
        #     before committing the changes
        # @example
        #     CloudFocus::Dasbhoard.where(default: false).first.update!(default: true)
        #     # This will automatically trigger this function and remove the *default* field from the old default dashboard
        def verify_default_dashboard
            if default
                dashboards = self.class.where.not(id: id).where(account: account)
                self.class.where.not(id: id).where(account: account).update_all(default: false)
            end

            unless self.class.where(account: account).find_by(default: true)
                errors.add(:base, I18n.t("core.dashboards.messages_danger_default_dashboard_must_exist"))
                raise ActiveRecord::Rollback
            end
        end

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     dynamic_info = CloudHelp::Dashboard.dynamic_info
        #     puts dynamic_info[:module_name] # will print 'help'
        #     puts dynamic_info[:component_model] # will print a new instance of CloudHelp::Dashboard::Component
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")

            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                full_module_name: module_info[0],
                component_model: "#{self.name}::Component".constantize
            }
        end
    end
end
