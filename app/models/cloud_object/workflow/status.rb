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
@description Base abstract model for *Workflow* *status* core entity used for workflows

=end
    class Workflow::Status < ApplicationRecord
        self.abstract_class = true

        validates :name, presence: true

=begin
@return [Boolean] Wheter the status was deleted or not
@description Attempts to delete this status.
    However, if there is a *workflow* associated to this *status*, it 
    will not be deleted and an error will be added to the *errors* parameter.
    States that are initial or final cannot be deleted.
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
                if initial || final
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
@description Returns a list of all the transitions from the current *status* to another one.
    The fields of each hash are *id* of the status, *name*, and wheter it is initial or final
@example
    workflow = CloudHelp::Workflow.find(1)
    initial_status = workflow.statuses.where(initial: true)
    transitions = initial_status.next_statuses
    puts transitions.to_json # will print something like
    #[
    #    {
    #        "id": 2,                       # The id of the status
    #        "name": "closed",              # The name of the status
    #        "final": true,                 # If the status is final or not
    #        "initial": null,               # If the status is initial or not
    #        "next_statuses": null          # List of transitions
    #    }
    #]
=end
        def next_workflow_statuses
            return [] unless next_statuses
            
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            numbers = next_statuses.split("|").map(&:to_i)
            
            workflow.statuses.where(number: numbers).order(number: :asc)
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
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase
            }
        end
    end
end
    