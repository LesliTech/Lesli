module Lesli
    class Role::ActionService < Lesli::ApplicationLesliService 

        def find id
            #super(current_user.account.users.joins(:detail).find_by(id: id))
            super(Lesli::Role::Action.with_deleted.find(id))
        end

        def index role_id

            def clean action 
                {
                    :id => action.id,
                    :role_id => action.role_id,
                    :action_id => action.action_id,
                    :deleted_at => action.deleted_at,
                    :active => action.active
                }
            end

            role_actions = {}

            Lesli::Role::Action.with_deleted.joins(system_controller_action: :system_controller)
            .where(:role_id => role_id)
            .select(
                :id,
                :role_id,
                :action_id,
                :deleted_at,
                "lesli_system_controllers.id as controller_id",
                "lesli_system_controllers.name as controller_name",
                "lesli_system_controller_actions.name as controller_action_name",
                "case when lesli_role_actions.deleted_at is null then TRUE else FALSE end active"
            ).each do |action|

                unless role_actions.has_key?(action[:controller_name])
                    role_actions[action[:controller_name]] = {
                        list:nil,
                        index: nil,
                        show:nil,
                        create:nil,
                        update:nil,
                        destroy:nil
                    }
                end

                if  action[:controller_action_name] == "list"
                    role_actions[action[:controller_name]][:list] = clean(action)
                end

                if  action[:controller_action_name] == "index"
                    role_actions[action[:controller_name]][:index] = clean(action)
                end

                if  action[:controller_action_name] == "show"
                    role_actions[action[:controller_name]][:show] = clean(action)
                end

                if  action[:controller_action_name] == "create"
                    role_actions[action[:controller_name]][:create] = clean(action)
                end

                if  action[:controller_action_name] == "update"
                    role_actions[action[:controller_name]][:update] = clean(action)
                end

                if  action[:controller_action_name] == "destroy"
                    role_actions[action[:controller_name]][:destroy] = clean(action)
                end
            end

            role_actions
        end
    end
end
