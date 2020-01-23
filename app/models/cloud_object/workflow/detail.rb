module CloudObject
=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Model for any workflow detail. Each detail is accessed only through its *workflow*, and
    represents one *cloud_object* *state*. Each detail also contains information about transitions to
    other details
=end
    class Workflow::Detail < ApplicationRecord
        self.abstract_class = true
                
=begin
@return [Array] List of hashes. Each hash represents an transition from this detail to
    another one.
@description Returns a list of all the transitions from the *state* associated to this detail,
    to other details. The fields of each hash are *id* of the detail, *name* of the state and
    *id* of the workflow detail
@example
    workflow = CloudHelp::TicketWorkflow.find(1)
    initial_detail = workflow.details.where(workflow_state: CloudHelp::TicketState.initial_state)
    transitions = initial_detail.next_states
    puts transitions.to_json # will print something like
    #[
    #    {
    #        "id": 2,                     # The id of the state
    #        "name": "closed",            # The name of the state
    #        "workflow_detail_id": 34     # the id of the workflow detail
    #    }
    #]
=end
        def next_workflow_states
            return [] unless next_states
            
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            ids = next_states.split('|').map(&:to_i)
            workflow.details.where("cloud_#{module_name}_#{object_name}_states_id".to_sym => ids).map do |workflow_detail|
                workflow_state = workflow_detail.workflow_state
                {
                    id: workflow_state.id,
                    name: workflow_state.name,
                    workflow_detail_id: workflow_detail.id
                }
            end
        end

        private

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Workflow::Detail.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:object_name] # will print ticket_workflow
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            cloud_object_name = module_info[1].sub("Workflow", "")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: "#{cloud_object_name.downcase}_workflow"
            }
        end
    end
end
