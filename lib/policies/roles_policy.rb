
class RolesPolicy < ApplicationLesliPolicy

    def index
        [
            'RolesController#list',
            'Role::ActivitiesController#index',
            'Role::DescribersController#index'
        ]
    end

    def show
        [
            'UserController#logout',
            'UserController#options',
            'User::SessionsController#index'
        ]
    end

    def create 
        [
            
        ]
    end

    def edit
        [
            'RolesController#options'
        ]
    end

    def destroy 
    end
end
