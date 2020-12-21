    module CloudObject
=begin

Copyright (c) 2020, all rights reserved.

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
    class Workflow < ApplicationLesliRecord
        self.abstract_class = true

        after_update :verify_default_workflow

=begin
@return [Boolean] Wheter the workflow was deleted or not
@description Attempts to delete this workflow.
    However, if there is a *cloud_object* associated to this *workflow*, it 
    will not be deleted and an error will be added to the *errors* parameter
@example
    my_workflow = CloudHelp::Workflow.first
    if my_workflow.destroy
        puts "workflow successfully destroyed"
    else
        puts "workflow was not destroyed"
        puts my_workflow.errors.full_messages.to_sentence
    end
=end
        def destroy
            if default
                errors.add(:base, :cannot_delete_default_workflow)
                return false
            end

            if deletion_protection
                errors.add(:base, :cannot_delete_protected_workflow)
                return false
            end

            begin
                super
            rescue ActiveRecord::InvalidForeignKey
                errors.add(:base, :foreign_key_prevents_destruction)
                false
            end
        end

=begin
@return [Hash] Hash of containing the information of the workflow and its statuses. 
@description Returns a hash with information about the workflow and all its *statuses* 
    that contain the transitions between *states*
@example
    workflow = CloudHelp::Workflow.first.full_workflow
    responseWithSuccessful(workflow)
=end
        def show
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            status_model = dynamic_info[:status_model]

            data = {}
            nodes = status_model.select(
                :id,
                :name,
                :number,
                :status_type,
                :next_statuses
            ).where(
                workflow: self
            ).order(
                number: :asc
            )

            statuses_count = 0
            nodes.each do |node|
                node = node.attributes
                statuses_count = statuses_count += 1    # This is a counter to get the status with the highest number (frontend use)
                node["new_number"] = node["number"]     # This is a frontend user value. Allows the user to change the number without the input moving
                node["visited"] = false                 # This is a flag for frontend use
                data[node["id"]] = node
            end

            {
                id: id,
                name: name,
                deletion_protection: deletion_protection,
                statuses_count: statuses_count,
                default: default,
                created_at: LC::Date.to_string_datetime(created_at),
                updated_at: LC::Date.to_string_datetime(updated_at),
                statuses: data
            }
        end

=begin
@param account [Account] Account from current user
@return [Array] Array of workflows. 
@description Retrieves and returns all workflows from an *Account*.
    Each workflow contains only the fields to be displayed in
    a table
@example
    account = current_user.account
    workflows = CloudHelp::Workflow.list(account)
=end
        def self.list(current_user, query)
            module_name = dynamic_info[:module_name]

            # preparing filters
            filters = query[:filters]
            filters_query = []

            # We create a filter by a text string written by the user
            if filters["query"] && !filters["query"].empty?
                filters_query.push(
                    "LOWER(cloud_#{module_name}_workflows.name) LIKE '%#{filters["query"].downcase}%'"
                )
            end
            
            # We apply defaul filters
            workflows = self.where(
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )

            # We apply the previous filters in the main query
            unless filters_query.empty?
                workflows = workflows.where(filters_query.join(' and '))
            end

            response = {}
            
            # We calculate total rows if needed
            response[:total_count] = workflows.count if filters["get_total_count"]

            # Adding pagination to workflows
            pagination = query[:pagination]
            workflows = workflows
            .page(pagination[:page])
            .per(pagination[:perPage])
            .order(pagination[:orderColumn].to_sym => pagination[:order].to_sym)
            
            response[:workflows] = workflows.select(
                :id,
                :default,
                :name,
                :created_at,
                :updated_at
            ).map do |workflow|
                workflow_attributes = workflow.attributes
                workflow_attributes["created_at"] = LC::Date.to_string_datetime(workflow_attributes["created_at"])
                workflow_attributes["updated_at"] = LC::Date.to_string_datetime(workflow_attributes["updated_at"])
                workflow_attributes["checks"] = workflow.monitoring_checks
                workflow_attributes
            end

            response
        end

        def monitoring_checks
            {
                initial_status: monitoring_check_initial_status(),
                floating_statuses: monitoring_check_floating_statuses(),
                missing_transitione: monitoring_check_missing_transitions(),
                associated: monitoring_check_associated()
            }
        end

        def monitoring_check_initial_status()
            if statuses.find_by(status_type: "initial")
                return {
                    passed: true
                }
            end

            return {
                passed: false,
                error_icon: "play",
                message: I18n.t("core.workflows.messages_warning_check_initial_status")
            }
        end

        def monitoring_check_floating_statuses()
            statuses_data = statuses.select(:id, :next_statuses, :status_type, :name)

            statuses_data.each do |active_status|
                status_type = active_status.status_type
                next if status_type == "initial"

                available_transitions = statuses_data.find do |status|
                    transitions = status.next_statuses
                    next unless transitions

                    (
                        transitions == "#{active_status.id}" || 
                        transitions.include?("|#{active_status.id}|") || 
                        transitions.start_with?("#{active_status.id}|") ||
                        transitions.end_with?("|#{active_status.id}")
                    )
                end
                
                next if available_transitions

                return {
                    passed: false,
                    error_icon: "unlink",
                    message: I18n.t("core.workflows.messages_warning_check_floating_statuses")
                }
            end

            return {
                passed: true
            }
        end

        def monitoring_check_missing_transitions()
            statuses_with_no_transitions = statuses.where(
                "next_statuses IS ? OR next_statuses = ?",
                nil,
                ""
            ).where(
                "status_type NOT IN (?)",
                ["completed_successfully", "completed_unsuccessfully", "to_be_deleted"]
            )

            if statuses_with_no_transitions.empty?
                return {
                    passed: true
                }
            end

            return {
                passed: false,
                error_icon: "project-diagram",
                message: I18n.t("core.workflows.messages_warning_check_missing_transitions")
            }
        end

        def monitoring_check_associated()
            if default || ! associations.empty? 
                return {
                    passed: true
                }
            end

            return {
                passed: false,
                error_icon: "clipboard-check",
                message: I18n.t("core.workflows.messages_warning_check_associated")
            }
        end

        protected
        
=begin
@return [void]
@description Checks if a workflow was changed to default. If it was, marks the previously
    default workflow as not detault. If it is unable to do it, raises an exception that
    triggers a rollback
=end
        def verify_default_workflow
            default_change = saved_changes["default"]
            return unless default_change
            
            if default_change[1]
                # default changed from false to true
                raise ActiveRecord::RecordInvalid, self unless self.class.where(
                    default: true,
                    account: account
                ).where.not(id: id).update(default: false)
            end
        end

        
=begin
@return [void]
@description Adds the *workflow_status* attribute to an existing *cloud_object*.
    based on the *cloud_object*'s attributes. Priority is: default workflow is least
    important, then goes global workflow of this table, then goes specific workflow of
    this table.
@example
    ticket_params = {
        detail_attributes: {
            cloud_help_ticket_priorities_id: 1,
            cloud_help_ticket_categories_id: 1,
            cloud_help_ticket_types_id: 1
        }
    }
    ticket = CloudHelp::Ticket.new(ticket_params)
    CloudHelp::Workflow.set_workflow(ticket)
    if ticket.save
        responseWithSuccessful
    else
        responseWithError(ticket.errors.full_messages.to_sentence)
    end
=end
        def self.set_workflow(cloud_object)
            dynamic_info_ = self.dynamic_info
            module_name = dynamic_info_[:module_name]
            status_model = dynamic_info_[:status_model]
            association_model = dynamic_info_[:association_model]
            account = cloud_object.account
            workflow_for = cloud_object.class.name.split("::")[-1].underscore.downcase

            
            # The first workflow option is the specific workflow
            association_details = association_model.object_association_details(workflow_for)

            unless association_details.empty?
                search_params = [
                    "cloud_#{module_name}_workflows.cloud_#{module_name}_accounts_id = #{cloud_object.account.id}",
                    "cloud_#{module_name}_workflow_associations.workflow_for = '#{workflow_for}'"
                ]

                order_params = []

                missing_required_field = false

                association_details.each do |detail|
                    case detail[:type]
                    when "foreign_key"
                        association_value = cloud_object[detail[:key]]
                    when "detail_enum"
                        association_value = "'#{cloud_object.detail[detail[:name]]}'"
                    when "polymorphic_key"
                        association_value = "'#{cloud_object[detail[:name]]}'"
                    end

                    # There is a required param missing for a specific association in the cloud_object model
                    unless association_value
                        missing_required_field = true 
                        break
                    end

                    search_params.push("
                        (cloud_#{module_name}_workflow_associations.#{detail[:name]} = #{association_value} OR 
                        cloud_#{module_name}_workflow_associations.#{detail[:name]} IS NULL)
                    ")

                    order_params.push("cloud_#{module_name}_workflow_associations.#{detail[:name]} NULLS LAST")
                end

                unless missing_required_field

                    workflow_associations = association_model.joins(
                        :workflow
                    ).where(
                        "cloud_#{module_name}_workflow_associations.global = FALSE OR cloud_#{module_name}_workflow_associations.global IS NULL"
                    ).where(
                        search_params.join(" AND ")
                    ).select(
                        "cloud_#{module_name}_workflows.id as id",
                        "cloud_#{module_name}_workflows.name as name"
                    )

                    order_params.each do |order_param|
                        workflow_associations = workflow_associations.order(order_param)
                    end

                    unless workflow_associations.empty?
                        workflow = self.find(workflow_associations[0][:id])
                        self.finish_workflow_assignation(cloud_object, workflow)
                        return
                    end
                end
            end


            # The second workflow option is the global workflow
            workflow_associations = association_model.joins(
                :workflow
            ).where(
                "
                    cloud_#{module_name}_workflows.cloud_#{module_name}_accounts_id = #{cloud_object.account.id} and
                    cloud_#{module_name}_workflow_associations.global = true and
                    cloud_#{module_name}_workflow_associations.workflow_for = '#{workflow_for}'
                "
            ).select(
                "cloud_#{module_name}_workflows.id as id",
                "cloud_#{module_name}_workflows.name as name"
            )

            unless workflow_associations.empty?
                workflow = self.find(workflow_associations[0][:id])
                self.finish_workflow_assignation(cloud_object, workflow)
                return
            end
        

            # The first workflow option is the default workflow
            workflow = self.find_by(
                default: true,
                account: account
            )

            if workflow
                self.finish_workflow_assignation(cloud_object, workflow)
            end
        end

=begin
@return [void]
@param account [Cloud[module_name]::Account] The account associated to this workflow
@description Initializes the default dummy workflow of the account. This method should be
    called as an after_create method in the account model.
@example
    house_account = CloudHouse::Account.new(::Account.find(1))
    # Rails will automatically execute an after_create method in the account model, and
    # that method will execute this method
=end
        def self.initialize_data(account)
            dynamic_info = self.dynamic_info
            module_name = dynamic_info[:module_name]

            default_workflow = self.create(
                name: "Default Workflow",
                default: true,
                account: account,
                deletion_protection: false,
                statuses_attributes: [
                    {
                        name: "created",
                        number: 1,
                        status_type: "initial"
                    },
                    {
                        name: "closed",
                        number: 2,
                        status_type: "completed_successfully"
                    }
                ]
            )

            default_workflow.statuses.find_by(
                status_type: "initial"
            ).update(
                next_statuses: "#{default_workflow.statuses.find_by(status_type: "completed_successfully").id}"
            )
        end

        private
        
        # If the new workflow is the old workflow, the status is not reset. This will only occur when
        # set_workflow is called for a cloud_object that has already another workflow associated
        def self.finish_workflow_assignation(cloud_object, workflow)
            return if cloud_object.status && cloud_object.status.workflow == workflow

            cloud_object.status = workflow.statuses.find_by(status_type: "initial")
        end
        
=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Workflow.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:status_model].new # will print a new instance of CloudHelp::Workflow::Status
    puts dynamic_info[:association_model] # will print a new instance of CloudHelp::Workflow::Association
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name,
                status_model: "#{self.name}::Status".constantize,
                association_model: "#{self.name}::Association".constantize
            }
        end
    end
end
