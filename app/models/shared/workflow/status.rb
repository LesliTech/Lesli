module Shared
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
    class Workflow::Status < ApplicationLesliRecord
        self.abstract_class = true

        validates :name, presence: true

        enum status_type: {
            initial: "initial",
            completed_successfully: "completed_successfully",
            completed_unsuccessfully: "completed_unsuccessfully",
            to_be_deleted: "to_be_deleted",
            normal: "normal"
        }
        

=begin
@return [Boolean] Wheter the status was deleted or not
@description Attempts to delete this status.
    However, if there is a *workflow* associated to this *status*, it 
    will not be deleted and an error will be added to the *errors* parameter.
    States that are initial cannot be deleted.
@example
    my_status = CloudHelp::Workflow::Status.first
    if my_status.destroy
        puts "Workflow status successfully destroyed"
    else
        puts "Workflow status was not destroyed"
        puts my_status.errors.full_messages.to_sentence
    end
=end
        def destroy
            begin
                if initial?
                    errors.add(:base, :destroy_attempt_on_default_status)
                    return false
                end
                super
            rescue ActiveRecord::InvalidForeignKey
                errors.add(:base, :foreign_key_prevents_destruction)
                false
            end
        end

=begin
@return [Array] List of hashes. Each hash represents an transition from this status to
    another one.
@param current_user [User] The user that is requesting the transition_statuses
@description Returns a list of all the transitions from the current *status* to another one.
    The fields of each hash are *id* of the status, *name*, and wheter it is initial or final
@example
    workflow = CloudHelp::Workflow.find(1)
    initial_status = workflow.statuses.where(status_type: "initial")
    transitions = initial_status.next_statuses
    puts transitions.to_json # will print something like
    #[
    #    {
    #        "id": 2,                       # The id of the status
    #        "name": "closed",              # The name of the status
    #        "final": true,                 # If the status is final or not
    #        "status_type": "normal",       # Enum value. List of available status types
    #        "next_statuses": null          # List of transitions
    #    }
    #]
=end
        def next_workflow_statuses(current_user, cloud_object)
            return [] unless next_statuses
            
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            module_underscore = dynamic_info[:module_underscore]

            ids = next_statuses.split("|").map(&:to_i)

            grant_destroy = false
            current_user.user_roles
            .joins(:role)
            .joins("inner join role_privileges as rp on rp.roles_id = roles.id")
            .where("rp.grant_object = ?", "#{module_underscore}/#{cloud_object.class.name.split("::").last.underscore.pluralize}")
            .select("rp.grant_destroy")
            .each do |privilege|
                if privilege.grant_destroy
                    grant_destroy = true
                    break
                end
            end
            
            workflow_including_deleted.statuses.where(id: ids).order(number: :asc).order(id: :asc).filter_map do |status|
                if status.to_be_deleted? && ! grant_destroy
                    nil
                else
                    status
                end
            end
        end

private

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Workflow::Status.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                module_underscore: module_info[0].underscore
            }
        end
    end
end
    