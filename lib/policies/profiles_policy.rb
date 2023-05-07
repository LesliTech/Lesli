class ProfilesPolicy < ApplicationLesliPolicy
    def show
        [
            'UsersController#options',
            'User::SessionsController#index',
            'Profile::SubscriptionsController#index',
            'Profile::SubscriptionsController#options',
            'Profile::NotificationsController#index',
            'CloudBell::AnnouncementsController#list',
        ]
    end
end
