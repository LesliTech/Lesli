
class RolesPolicy < ApplicationLesliPolicy
    def show
        [
            'Role::DescriptorsController#index',
            'Role::DescriptorsController#create',
            'Role::DescriptorsController#destroy'
        ]
    end
end
