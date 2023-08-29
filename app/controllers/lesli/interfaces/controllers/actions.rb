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
module Interfaces
    module Controllers
        module Actions
            # @return [Json] Json that contains a list of all actions related to a *cloud_object*
            # @description Retrieves and returns all actions associated to a *cloud_object*. The id of the
            #     *cloud_object* is within the *params* attribute. If the child class provides a block, the function is
            #     yielded sending the actions as parameters. The block given *must* return the HTTP response
            # @example
            #     # Executing this controller's action from javascript's frontend
            #     let ticket_id = 1;
            #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/actions`);
            def index
                set_cloud_object
                action_model = action_model() # If there is a custom action model, it must be returned in this method
                action_model.cloud_object_model

                @actions = action_model.index(current_user, @cloud_object)
                if block_given?
                    yield(@actions)
                else
                    respond_with_successful(@actions)
                end
            end

            # @return [JSON] The json information about the selected action
            # @description Retrieves and returns the information about the action. The id of the
            #     *cloud_object* and the id of the *action* are within the *params* attribute. If a block
            #     is provided, the execution will be yielded sending the action as first parameter
            # @example
            #     # Executing this controller's action from javascript's frontend
            #     let ticket_id = 1;
            #     let action_id = 5;
            #     this.http.get(`127.0.0.1/help/tickets/${ticket_id}/actions/${action_id}`);
            def show
                set_action
                return respond_with_not_found unless @action

                return respond_with_successful(@action) unless block_given?

                yield(@action)
            end

            # @controller_action_param :content [String] The commented message
            # @controller_action_param :actions_id [Integer] The id of a actions that this message responds to
            # @return [Json] Json that contains wheter the creation of the action was successful or not.
            #     If it is not successful, it returs an error message
            # @description Creates a new action associated to a *cloud_object* and notifies all users subscribed to this event.
            #     The id of the *cloud_object* is within the *params* attribute
            # @example
            #     # Executing this controller's action from javascript's frontend
            #     let ticket_id = 1;
            #     let data = {
            #         ticket_action: {
            #             content: "This is a comment on a ticket!"
            #         }
            #     };
            #     this.http.post(`127.0.0.1/help/tickets/${ticket_id}/actions`, data);
            def create
                action_model = action_model() # If there is a custom action model, it must be returned in this method
                action_model.cloud_object_model

                set_cloud_object
                new_action_params = action_params.merge(
                    user_creator: current_user
                )

                action = @cloud_object.actions.new(new_action_params)
                if action.save
                    if block_given?
                        yield(cloud_object, action)
                    else
                        respond_with_successful(action.show(current_user))
                    end
                else
                    respond_with_error(action.errors.full_messages)
                end
            end

            # @controller_action_param :content [String] The content of the action
            # @controller_action_param :actions_id [Integer] The id of a actions that this message responds to
            # @return [Json] Json that contains wheter the update of the action was successful or not.
            #     If it is not successful, it returs an error message
            # @description Updates the action based on the id of the *cloud_object* and its own id.
            # @example
            #     # Executing this controller's action from javascript's frontend
            #     let ticket_id = 1;
            #     let action_id = 22;
            #     data = {
            #         action: {
            #             content: "This is the new content of the action"
            #         }
            #     };
            #     this.http.patch(`127.0.0.1/help/tickets/${ticket_id}/actions/${action_id}`, data);
            def update
                set_action
                return respond_with_not_found unless @action
                return respond_with_unauthorized unless @action.is_editable_by?(current_user)

                if @action.update(action_params)
                    respond_with_successful(@action.show(current_user))
                else
                    respond_with_error(@action.errors.full_messages.to_sentence)
                end
            end

            # @return [Json] A response that contains wheter the action was deleted or not.
            #     If it is not successful, it returns an error message
            # @description Deletes a action from the database based on the id of the *cloud_object* and its own id.
            # @example
            #     # Executing this controller's action from javascript's frontend
            #     let ticket_id = 1;
            #     let action_id = 22;
            #     this.http.delete(`127.0.0.1/help/tickets/${ticket_id}/actions/${action_id}`);
            def destroy
                set_action
                return respond_with_not_found unless @action

                if @action.destroy
                    respond_with_successful
                else
                    respond_with_error(@action.errors.full_messages.to_sentence)
                end
            end

            protected

            # @return [Parameters] Allowed parameters for the action
            # @description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
            #     Allowed params are _:content_, _:actions_id_.
            # @example
            #     # supose params contains {
            #     #    "ticket_action": {
            #     #        "id": 5,
            #     #        "content": "This is a message!",
            #     #        "cloud_help_ticket_actions_id": 4
            #     #    }
            #     #}
            #     action_params = action_params
            #     puts action_params
            #     # will remove the _id_ field and only print {
            #     #    "ticket_action": {
            #     #        "content": "This is a message!",
            #     #        "cloud_help_ticket_actions_id": 4
            #     #    }
            #     #}
            def action_params
                action_model = action_model() # If there is a custom action model, it must be returned in this method
                cloud_object_model = action_model.cloud_object_model

                params.require(
                    "#{cloud_object_model.name.demodulize.underscore}_action".to_sym
                ).permit(
                    :instructions,
                    :complete,
                    :group,
                    "#{action_model.table_name}_id".to_sym
                )
            end

            # @return [void]
            # @descriptions Sets the variable @cloud_object based on the paremeters send in the URL. If no,
            #     cloud_object is found or it is not within the current_user's account, nil is used instead
            # @example
            #     # Imagine you are inside CloudFocus::Task::ActionsController
            #     puts @cloud_object # will display nil
            #     set_cloud_object
            #     puts @cloud_object # Will display an instance of CloudFocus::Task
            def set_cloud_object
                action_model = action_model() # If there is a custom action model, it must be returned in this method
                cloud_object_model = action_model.cloud_object_model
                account_model = cloud_object_model.reflect_on_association(:account).klass

                @cloud_object = cloud_object_model.find_by(
                    id: params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym],
                    "#{account_model.table_name}_id".to_sym => current_user.account.id
                )
            end

            # @return [void]
            # @description Sets the variable @action. The variable contains the action
            #     to be updated based on the id of the *cloud_object* and the id of the *action*
            # @example
            #     #suppose params[:ticket_id] = 1
            #     #suppose params[:id] = 44
            #     puts @action # will display nil
            #     set_action
            #     puts @action # will display an instance of CloudHelp:Ticket::Action
            def set_action
                action_model = action_model() # If there is a custom action model, it must be returned in this method
                cloud_object_model = action_model.cloud_object_model
                account_model = cloud_object_model.reflect_on_association(:account).klass

                @action = action_model.joins(:cloud_object).where(
                    "#{cloud_object_model.table_name}.id = #{params["#{cloud_object_model.name.demodulize.underscore}_id".to_sym]}",
                    "#{cloud_object_model.table_name}.#{account_model.table_name}_id = #{current_user.account.id}"
                ).find_by(
                    id: params[:id]
                )
            end

            # @return [CloudObject::Action] The action model that the controller will handle
            # @descriptions Constantizes and returns the action model associated to this controller. This method
            #      can be overrided by the implementation in the child controller
            # @example
            #     # Suppose you are inside CloudHelp::Ticket::ActionsController
            #     puts action_model().new
            #     # This will display a new instance of CloudHelp::Ticket::Action
            def action_model
                self.class.name.gsub("Controller", "").singularize.constantize
            end
        end
    end
end
