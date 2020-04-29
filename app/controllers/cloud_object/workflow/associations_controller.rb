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
@description Base controller for *workflow* *associations* core entity. A workflow association indicates
    which workflow belongs to which *cloud_object*
=end
    class Workflow::AssociationsController < ApplicationLesliController
        before_action :set_workflow, only: [:index, :create, :association_options]
        before_action :set_workflow_association, only: [:destroy]


=begin
@return [HTML|JSON] HTML view for listing all workflow associations or a Json that contains a list 
    of all workflows associated to this *account*
@description Retrieves and returns all workflow associations associated to a *CloudHelp::Account*. 
    The account is obtained directly from *current_user*. The HTTP request has to specify
    wheter the HTML or the JSON text should be rendered
@example
    # Executing this controller's action from javascript's frontend
    let workflow_id = 4;
    this.http.get(`127.0.0.1/help/workflows/${workflow_id}/associations`);
=end
        def index
            respond_to do |format|
                format.html {}
                format.json do
                    return responseWithNotFound unless @workflow

                    dynamic_info = self.class.dynamic_info
                    model = dynamic_info[:model]
                    
                    
                    responseWithSuccessful(model.list(@workflow))
                end
            end
        end

=begin
@controller_action_param :workflow_for [String] The name of the *cloud_object* this workflow is assigned to
@controller_action_param :global [Boolean] Wheter this association is global or not
@return [Json] Json that contains wheter the creation of the workflow association was successful or not. 
    If it is not successful, it returns an error message
@description Creates a new workflow association associated to the *current_user*'s *account*
@example
# Executing this controller's action from javascript's frontend
    let workflow_id = 5;
    let data = {
        workflow_association: {
            workflow_form: "projects",
            global: true
        }
    };
    this.http.post('127.0.0.1/help/workflows/${workflow_id}/associations', data);
=end
        def create
            return responseWithNotFound unless @workflow

            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            association = model.new(association_params)
            association.workflow = @workflow

            if association.save
                responseWithSuccessful(association)
            else
                responseWithError(association.errors.full_messages.to_sentence)
            end
        end

=begin
@return [Json] Json that contains wheter the workflow was successfully deleted or not. 
    If it it not successful, it returns an error message
@description Deletes an existing *workflow* associated to the *current_user*'s *account*.
    Since the workflow has details, these are also deleted. However, if there
    is an existing *cloud_object* associated to the *workflow*, it cannot be deleted
@example
    # Executing this controller's action from javascript's frontend
    let workflow_id = 4;
    let association_id = 9;
    this.http.delete(`127.0.0.1/help/workflows/${workflow_id}/associations/${association_id}`);
=end
        def destroy
            return responseWithNotFound unless @workflow_association

            if @workflow_association.destroy
                responseWithSuccessful
            else
                responseWithError(@workflow_association.errors.full_messages.to_sentence)
            end
        end


=begin
@return [JSON] A list of global associations of the workflow
@description Obtains a list of all the global associations of this workflow. A global association
    is an entry in the cloud_[engine]_[object]_workflows that has the 'global' attribute set to true
=end
        def association_options
            dynamic_info = self.class.dynamic_info
            model = dynamic_info[:model]

            responseWithSuccessful(model.association_options(current_user.account))
        end

private

=begin
@return [void]
@description Sets the variable @workflow. The variable contains the *cloud_object* *workflow* 
    to be handled by the controller action that called this method
@example
    #suppose params[:workflow_id] = 1
    puts @workflow # will display nil
    set_workflow
    puts @workflow # will display an instance of CloudHelp::Workflow
=end
        def set_workflow
            dynamic_info = self.class.dynamic_info
            workflow_model = dynamic_info[:workflow_model]
            module_name = dynamic_info[:module_name]

            @workflow = workflow_model.find_by(
                id: params[:workflow_id],
                "cloud_#{module_name}_accounts_id".to_sym => current_user.account.id
            )
        end

=begin
@return [void]
@description Sets the variable @workflow_assigned, along the variable @workflow.
    The variable contains the *workflow_association* to be handled by the controller action that called this method
@example
    # suppose params[:workflow_id] = 2
    # suppose params[:id] = 4
    puts @workflow # will display nil
    puts @workflow_association # will display nil
    set_workflow_association
    puts @workflow # will display an instance of CloudHelp::Workflow
    puts @workflow_association # will display an instance of CloudHelp::Workflow::Association
=end
        def set_workflow_association
            set_workflow
            @workflow_association = @workflow.associations.find_by(id: params[:id])
        end

=begin
@return [Parameters] Allowed parameters for the workflow
@description Sanitizes the parameters received from an HTTP call to only allow the specified ones.
    If there are extra allowed params, they must be implemented on the subclass
@example
    # supose params contains {
    #    workflow_association: {
    #       workflow_for: 'projects'
    #       id: 10
    #    }
    #}
    filtered_params = association_params
    puts filtered_params
    # will remove the unpermitted params and only print {
    #       workflow_for: 'projects'
    #    }
=end
        def association_params
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            params.require(:workflow_association).permit(
                :workflow_for
            )
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Workflow::AssociationsController < CloudObject::Workflow::AssociationsController
    info = dynamic_info
    puts info[:module_name] # will print 'help'
    puts info[:model].new # will return an instance of CloudHelp::Workflow::Association
    puts info[:workflow_model] # will return an instance of CloudHelp::Workflow
=end
        def self.dynamic_info
            module_info = self.name.split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                model: "#{module_info[0]}::Workflow::Association".constantize,
                workflow_model: "#{module_info[0]}::Workflow".constantize
            }
        end
    end
end
