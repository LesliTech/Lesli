module CloudObject
    class Dashboard < ApplicationLesliRecord
        self.abstract_class = true

        belongs_to :user_creator, class_name: "User", foreign_key: "users_id", optional: true

        after_update :verify_default_dashboard
        after_create :verify_default_dashboard

        def self.initialize_data(account)
            self.create!(
                account: account,
                name: "Default Dashboard"
            )
        end

=begin
@return [Hash] Hash of containing the information of the dashboard and its statuses. 
@description Returns a hash with information about the dashboard and all its *statuses* 
    that contain the transitions between *states*
@example
    dashboard = CloudHelp::Dashboard.first.full_dashboard
    responseWithSuccessful(dashboard)
=end
        def show
            attributes.merge({
                components: components.order(index: :asc)
            })
        end

        def self.list(current_user, query)
            dynamic_info = self.dynamic_info
            module_name = dynamic_info[:module_name]

            dashboards = self.where(
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            ).order(
                query[:pagination][:orderColumn].to_sym => query[:pagination][:order].to_sym
            )

            # We filter by a text string written by the user
            if query[:filters][:query] && !query[:filters][:query].empty?
                query_words = query[:filters][:query].split(" ")
                query_words.each do |query_word|
                    query_word = query_word.strip.downcase
                    dashboards = dashboards.where("LOWER(name) LIKE ?", "%#{query_word}%")
                end
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

        def self.options(current_user, query)
            dynamic_info = self.dynamic_info
            component_model = dynamic_info[:component_model]

            roles = current_user.account.roles.joins(
                :detail
            ).select(
                "roles.id", "role_details.name"
            ).order(
                "role_details.name asc"
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

            {
                roles: roles,
                component_ids: component_ids,
                components_configuration_options: component_model.configuration_options
            }
        end

        def destroy
            if default
                errors.add(:base, :cannot_delete_default_dashboard)
                return false
            end

            super
        end

        private

        def verify_default_dashboard
            if default
                dashboards = self.class.where.not(id: id).where(account: account)
                puts dashboards.to_json
                self.class.where.not(id: id).where(account: account).update_all(default: false)
            end
        end
        
=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Dashboard.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:component_model].new # will print a new instance of CloudHelp::Dashboard::Status
    puts dynamic_info[:component_model] # will print a new instance of CloudHelp::Dashboard::Component
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                component_model: "#{self.name}::Component".constantize
            }
        end
    end
end
