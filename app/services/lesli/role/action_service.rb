module Lesli
    class Role::ActionService < Lesli::ApplicationLesliService 

            def index params

                role_actions = {}

                Lesli::Role::Action.joins(system_controller_action: :system_controller)
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
                        role_actions[action[:controller_name]][:list] = action
                    end

                    if  action[:controller_action_name] == "index"
                        role_actions[action[:controller_name]][:index] = action
                    end

                    if  action[:controller_action_name] == "show"
                        role_actions[action[:controller_name]][:show] = action
                    end

                    if  action[:controller_action_name] == "create"
                        role_actions[action[:controller_name]][:create] = action
                    end

                    if  action[:controller_action_name] == "update"
                        role_actions[action[:controller_name]][:update] = action
                    end

                    if  action[:controller_action_name] == "destroy"
                        role_actions[action[:controller_name]][:destroy] = action
                    end
                end

                role_actions
            end
        end
end
