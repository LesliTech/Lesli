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
@description Base abstract model for *Workflow* *state* core entity used for workflows

=end
    class Workflow::Status < ApplicationRecord
        self.abstract_class = true

        validates :name, presence: true

=begin
@return [Boolean] Wheter the state was deleted or not
@description Attempts to delete this state.
    However, if there is a *workflow* associated to this *state*, it 
    will not be deleted and an error will be added to the *errors* parameter.
    States that are initial or final cannot be deleted.
@example
    my_state = CloudHelp::TicketState.first
    if my_state.destroy
        puts "Ticket state successfully destroyed"
    else
        puts "Ticket state was not destroyed"
        puts my_state.errors.full_messages.to_sentence
    end
=end
        def destroy
            begin
                if initial || final
                    errors.add(:base, :destroy_attempt_on_default_state)
                    return false
                end
                super
            rescue ActiveRecord::InvalidForeignKey
                errors.add(:base, :foreign_key_prevents_destruction)
                false
            end
        end

private

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::TicketWorkflowState.dynamic_info
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
    