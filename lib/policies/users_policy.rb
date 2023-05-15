
class UsersPolicy < ApplicationLesliPolicy
    def show
        [
            'UsersController#logout',
            'UsersController#options',
            'User::SessionsController#index'
        ]
    end
    def index 
        [
            'User::SessionsController#index'
        ]
    end
end
