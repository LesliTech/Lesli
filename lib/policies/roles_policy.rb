
class RolesPolicy < ApplicationLesliPolicy

    def index
    end

    def show
        [
            'Role::DescriptorsController#create',
            'Role::DescriptorsController#destroy'
        ]
    end

    def create 
    end

    def edit
        [
            'RolesController#options'
        ]
    end

    def destroy 
    end
end
