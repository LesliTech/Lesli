=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

module Lesli
    module Shared
        class Dashboard < ::Lesli::ApplicationLesliRecord
            self.abstract_class = true

            belongs_to :user_creator, class_name: "User", foreign_key: "users_id", optional: true

            after_update :verify_default_dashboard
            after_create :verify_default_dashboard

            enum component_ids: {}

            # @return [void]
            # @param account [LesliEngine::Account]
            # @description Initializes a default dummy dashboard for the account. This guarantees that the users
            #     will be able to access the dashboard page. Even if it's empty.
            # @example
            #     # Imagine you are adding a new engine to your instance (CloudProposal)
            #     # To execute this function, you must only do
            #     my_account = Account.first
            #     my_account.proposal = CloudProposal::Account.new
            def self.initialize_dashboard(modelo, account, components)

                components.unshift({
                    name: "Engine version",
                    component_id: "engine-version",
                    layout: 2,
                    query_configuration: {},
                    custom_configuration: {}
                })

                modelo.create_with(
                    default: true,
                    main: false,
                    components_attributes: components
                ).find_or_create_by!(
                    account: account,
                    name: "Default Dashboard"
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
                    # components: [{
                    #     name: "ticket",
                    #     component_id: "ticket"
                    # },{
                    #     name: "ticket",
                    #     component_id: "ticket"
                    # }]
                })
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
                component_model = dynamic_info[:module_model_component]

                component_ids = component_model.component_ids.map do |comp|
                    {
                        value: comp,
                        text: comp
                    }
                end

                options = {
                    component_ids: component_ids,
                    #components_configuration_options: component_model.configuration_options,
                    descriptions: {}
                }

                if block_given?
                    yield(options)
                else
                    return options
                end
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

            # Build the Rails models and engine information for 
            # the current engine implementing the shared dashboards
            # Example: For the LesliAudit engine
            # {
            #     :module_name => "audit", 
            #     :module_name_full => "LesliAudit", 
            #     :module_model => "LesliAudit::Dashboard", 
            #     :module_model_component => "LesliAudit::Dashboard::Component"
            # }
            def self.dynamic_info

                module_info = self.name.split("::")

                module_name = module_info[0].sub("Lesli", "").downcase
                
                {
                    module_name: module_name,
                    module_name_full: module_info[0],
                    module_model: "#{ module_info[0] }::Dashboard".constantize,
                    module_model_component: "#{ module_info[0] }::Dashboard::Component".constantize
                }
            end
        end
    end
end
