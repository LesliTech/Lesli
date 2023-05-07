
class UsersPolicy < ApplicationLesliPolicy
    def show
        [
            'UserController#logout',
            'UserController#options',
            'User::SessionsController#index'
        ]
    end
end
