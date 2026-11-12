# frozen_string_literal: true

module Lesli
    # Core exposes only the account-scoped role lookup needed by selectors.
    # Role administration belongs to the authentication/authorization engine
    # and is implemented by LesliShield::RoleService.
    class RoleService < Lesli::ApplicationLesliService
        def find(id)
            super(current_user.account.roles.find_by(id: id))
        end

        def list(_params = nil)
            current_user.account.roles
                .where(permission_level: ..current_user.max_level_permission)
                .order(permission_level: :desc, name: :asc)
                .select(:id, :name, :permission_level)
        end
    end
end
