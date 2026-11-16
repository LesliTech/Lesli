# frozen_string_literal: true

module Lesli
    # Core exposes only the account-scoped role lookup needed by selectors.
    # Role administration belongs to the authentication/authorization engine
    # and is implemented by LesliShield::RoleService.
    class RoleService < Lesli::ApplicationLesliService
        def find(id)
            super(current_user.account.roles.find_by(id: id))
        end

        # Return the roles available to the current user for selection.
        def list
            current_user.account.roles
                .where(permission_level: ..current_user.max_level_permission)
                .order(permission_level: :desc, name: :asc)
                .select(:id, :name)
        end
    end
end
