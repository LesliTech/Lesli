# Workflows and Workflow Actions

## Workflows
---
Every engine must have its own set of workflows, this means that the engine must have its own Model, Controller, Views and Migrations, each of this must inherit from Shared::Workflow in its own way. This set of core model, controller, views and migrations includes methods, helpers, validations and all the necessary of the functionality code and logic to made the workflow magic works correctly and integrate the functionality, actions, statuses and associations of the engine with the whole platform.

So when you create a new engine you must generate the specifics scaffolds for:
- workflow
- workflow/action
- workflow/association
- workflow/status

And then modify the files to make them look like the following.

---
### Controllers
---
**workflows_controller.rb**
```ruby
module CloudHelp
    class WorkflowsController < Shared::WorkflowsController
    end
end
```

**workflow/actions_controller.rb**
```ruby
module CloudHelp
    class Workflow::ActionsController < Shared::Workflow::ActionsController
    end
end
```

**workflow/associations_controller.rb**
```ruby
module CloudHelp
    class Workflow::AssociationsController < Shared::Workflow::AssociationsController

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
                :workflow_for,
                :global,
            )
        end

    end
end
```

**workflow/statuses_controller.rb**
```ruby
module CloudHelp
    class Workflow::StatusesController < Shared::Workflow::StatusesController   
    end
end
```

---
### Models
---
**workflow.rb**
```ruby
module CloudHelp
    class Workflow < Shared::Workflow
        belongs_to  :account,       class_name: "Account",                  foreign_key: "cloud_help_accounts_id"
        has_many    :associations,  class_name: "Workflow::Association",    foreign_key: "cloud_help_workflows_id"
        has_many    :actions,       class_name: "Workflow::Action",         foreign_key: "cloud_help_workflows_id"
        
        has_many(
            :statuses,
            inverse_of: :workflow,
            class_name: "Workflow::Status",
            foreign_key: "cloud_help_workflows_id",
            dependent: :delete_all
        )

        accepts_nested_attributes_for :statuses, allow_destroy: true
    end
end
```

**workflow/action.rb**
```ruby
module CloudHelp
    class Workflow::Action < Shared::Workflow::Action
        belongs_to :workflow, class_name: "Workflow", foreign_key: "cloud_help_workflows_id"
        belongs_to :workflow_including_deleted, class_name: "Workflow", foreign_key: "cloud_help_workflows_id", with_deleted: true
        belongs_to :initial_status, class_name: "Workflow::Status", foreign_key: "initial_status_id", optional: true
        belongs_to :final_status, class_name: "Workflow::Status", foreign_key: "final_status_id"

    end
end
```

**workflow/association.rb**
```ruby
module CloudHelp
    class Workflow::Association < Shared::Workflow::Association
        belongs_to :workflow, class_name: "Workflow", foreign_key: "cloud_help_workflows_id"

        # @return [Hash] A list of all available associations that can be created
        # @description Returns a hash where the key is the condensed name of the association and the value is the same.
        #     This previously was an enum that was changed due to issues with the new version of rails 6.1.0
        # @example
        #     CloudHelp::Workflow.first.associations.create!(
        #         workflow_for: CloudHelp::Workflow::Association.object_associations[:ticket],
        #         global: true
        #     )
        def self.object_associations
            return {
                ticket: "ticket"
            }
        end
    end
end
```

**workflow/status.rb**
```ruby
module CloudHelp
    class Workflow::Status < Shared::Workflow::Status
        belongs_to :workflow, inverse_of: :statuses, class_name: "Workflow", foreign_key: "cloud_help_workflows_id"
        belongs_to :workflow_including_deleted, class_name: "Workflow", foreign_key: "cloud_help_workflows_id", with_deleted: true, optional: true
    end
end
```

---
### Views (Vue)
---
**vue/workflows/app.js**
```js
// · List of Imported Components
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import app from 'LesliVue/app'

// · Import common apps
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
import appList  from 'LesliVue/shared/workflows/apps/list.vue'
import appEdit  from 'LesliVue/shared/workflows/apps/edit.vue'
import appShow  from 'LesliVue/shared/workflows/apps/show.vue'
import appNew   from 'LesliVue/shared/workflows/apps/new.vue'


const props = {
    cloudEngine: "CloudHelp",
    engineNamespace: "help"
}

// · 
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
app("CloudHelp", "[list|new|edit|show]", "/help/workflows", [{
    path: "/",
    component: appList,
    props: props
},{
    path: "/new",
    component: appNew,
    props: props
},{
    path: "/:id",
    component: appShow,
    props: props
},{
    path: "/:id/edit",
    component: appEdit,
    props: props
}])
```

This enable all the workflow functionality on the engine, and now we are able to create workflows, actions and statuses. These could be created on the on the initialization of the engine or during runtime. An example of the creation on the initialization is the following: 

On app/models/mitwerken_cloud/workflow.rb
```ruby
module MitwerkenCloud
    class Workflow < Shared::Workflow
        belongs_to :account, class_name: "Account", foreign_key: "mitwerken_cloud_accounts_id"
        has_many :associations, class_name: "Workflow::Association", foreign_key: "mitwerken_cloud_workflows_id"
        has_many :actions, class_name: "Workflow::Action", foreign_key: "mitwerken_cloud_workflows_id"

        has_many(
            :statuses,
            inverse_of: :workflow,
            class_name: "Workflow::Status",
            foreign_key: "mitwerken_cloud_workflows_id",
            autosave: true
        )

        accepts_nested_attributes_for :statuses, allow_destroy: true

        def self.initialize_match_workflow(main_account)
            match_workflow = MitwerkenCloud::Workflow.create!(
                account: main_account,
                name: "Match Workflow",
                deletion_protection: true,
                default: false,
                statuses_attributes: [
                    {
                        number: 1,
                        name: "created",
                        status_type: "initial",
                        next_statuses: ""
                    },
                    {
                        number: 2,
                        name: "confirmed",
                        status_type: "normal",
                        next_statuses: ""
                    },
                    {
                        number: 3,
                        name: "finished",
                        status_type: "completed_successfully",
                        next_statuses: ""
                    }
                ]
            )

            # These are the possible statuses that the associated objects could be on.
            match_statuses = MitwerkenCloud::Workflow.find_by(name: "Match Workflow").statuses
            created = match_statuses.find_by(name: "created")
            confirmed = match_statuses.find_by(name: "confirmed")
            finished = match_statuses.find_by(name: "finished")

            # These are the next possible statuses that each status could reach.
            created.update_attribute(:next_statuses, "#{confirmed.id}")
            confirmed.update_attribute(:next_statuses, "#{finished.id}")

            # This workflow is associated to the MitwerkenCloud::Match objects
            match_workflow.associations.create!(
                workflow_for: "match",
                global: true
            )

            # This is an action that send a message when an associated object change status to confirmed.
            match_workflow.actions.create!(
                name: "Confirm match message",
                final_status_id: confirmed.id,
                action_type: "send_talk_chatroom_message",
                active: true,
                execute_immediately: false,
                system_data: {},
                input_data: {
                    message_text: "Congratulations! You just confirm a match. %global_identifier%. %current_user%."
                },
                concerning_users: {
                    list: [{ name: "Mitwerken Development ", id: 1 }], type: "custom"
                },
                configuration: {}
            )
        end
    end
end
```


---
## Workflow Actions
---
Now we can talk about the workflow actions. These are the ones that help us to execute some funcionality when something happens. For example, we want to send an email to the manager every time that a project is created... in this case we can define a workflow **associated** to the Project model of the engine, then create the **statuses** "created" and "finished" and then we create an **action of type** "send_core_email" that respond to the status "created", specificy the receiver of the email and describe what we want the email to said. And now, every time that someone creates a project the server automatically will send the email to the respective user or email.

### Action Types

Note that we mention an action type, the action type is limited by the platform and the engines installed. There are different action types provided by different engines. By now, we provide this action types and each one have a specific functionality:

* (**Core**) send_core_email
    - Send an email
* (**Bell**) create_bell_notification
    - Create a CloudBell::Notification, (an inside platform notification Web or Mobile)
* (**Focus**) create_focus_task
    - Create a CloudFocus::Task
* (**Core**) cloud_object_clone
    - Clone a platform cloud_object
* (**Core**) create_cloud_object_file
    - Create a file for a platform cloud_object
* (**Talk**) send_talk_chatroom_message
    - Send a message via CloudOne and displayed by CloudTalk

There are important steps on the creation of an action type:

1. First, we decide an original name for our new action type, this must be defined by an action, engine and object like this: action_engine_object. For example: "create_focus_task". And then we add this action type name to the action_type enum located at app/models/shared/workflow/action.rb

2. Now, we must create the form component that we will use to create an action of that new specific action type at runtime, this form components are located on lib/vue/shared/workflows/components/actions/forms/. Here we create the new form with the relevant and necessary inputs. This file must have the same name as the action type that we are creating.

3. Then we have to import and use the new form component on the principal form located at lib/vue/shared/workflows/components/actions/form.vue. And now we are able to see the new form when we select to create a new action of the new type.

4. Finally, we have to create the Job that the action will execute. Create the Job file with the same action type name on the directory app/jobs/workflow_actions/. This Job is the one in charge of get the concerning users of the action and the replacement of variables in the text, and then execute the funcionality code. This functionality could be in the job, but commonly when the action is related to other engine functionality we call the respective Courier method. When we done with the Job, we have to call it from the method **execute** located on app/models/shared/workflow/action.rb on the case-when statement. Example:

```ruby
class WorkflowActions::SendTalkChatroomMessageJob < ApplicationJob
     queue_as :default

     def perform(current_user, cloud_object, action)

         sender_user = nil

         case action.concerning_users["type"]
         when "creator"
             sender_user = cloud_object.user_creator
         when "main"
             sender_user = cloud_object.user_main
         when "custom"
             sender_user = current_user.account.users.find(action.concerning_users["list"][0]["id"]) if action.concerning_users["list"]
         when "current_user"
             sender_user = current_user
         end

         begin
             replacement_values = {
                 "%global_identifier%" => cloud_object.global_identifier,
                 "%current_user%" => (current_user.full_name || "")
             }

             action.parse_input_data(replacement_values)
             input_data = action.input_data

             class_data = cloud_object.class.name.split("::")

             Courier::One::Firebase::Chatroom.send_message(
                 sender_user,
                 cloud_object.chatroom_external_id,
                 input_data["message_text"]
             )

         rescue StandardError => e
             if action.configuration["log_errors"]
                 cloud_object.activities.create(
                     user_creator: current_user,
                     category: "action_workflow_action_failed",
                     description: e.message
                 )
             end
         end
     end
 end
```
