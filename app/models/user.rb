=begin

Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class User < ApplicationLesliRecord

    include UserGuard
    include UserExtensions
    include UserActivities
    include UserPolyfill

    acts_as_paranoid

    validates :email, :presence => true

    devise  :database_authenticatable,
            :registerable,
            :rememberable,
            :recoverable,
            :validatable,
            :confirmable,
            :trackable,
            :omniauthable, omniauth_providers: [:google_oauth2, :facebook]


    # user details are saved on separate table
    has_one :detail, inverse_of: :user, autosave: true, foreign_key: "users_id", dependent: :destroy
    accepts_nested_attributes_for :detail, update_only: true


    # users belongs to an account only... and must have a role
    belongs_to :account, foreign_key: "accounts_id", optional: true
    belongs_to :role, foreign_key: "roles_id", optional: true


    # users data extensions
    has_many :logs,             foreign_key: "users_id", inverse_of: :user
    has_many :agents,           foreign_key: "users_id"
    has_many :settings,         foreign_key: "users_id"
    has_many :sessions,         foreign_key: "users_id"
    has_many :requests,         foreign_key: "users_id"
    has_many :shortcuts,        foreign_key: "users_id"
    has_many :activities,       foreign_key: "users_id"
    has_one  :integration,      foreign_key: "users_id"
    has_many :access_codes,     foreign_key: "users_id"
    has_many :auth_providers,   foreign_key: "users_id"


    # users can have many roles and too many privileges through the roles
    has_many :user_roles,       foreign_key: "users_id",    class_name: "User::Role"
    has_many :roles,            through: :user_roles,       source: :roles
    has_many :privileges,       through: :roles


    # callbacks
    before_create :before_create_user
    after_create :after_create_user
    after_create :after_confirmation_user, if: :confirmed?
    after_create :after_account_assignation


    # type of user
    #   system user
    #   integration apps
    enum category: { user: "user", integration: "integration" }


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def save(*args)
        super()
        rescue ActiveRecord::RecordNotUnique => error
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def user_creator
        return nil
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    def user_main
        return self
    end


    # @return [void]
    # @description Before creating a user we make sure there is no capitalized email
    def before_create_user
        self.email = (self.email||"").downcase
    end


    # @return [void]
    # @description After creating a user, creates the necessary resources for them to access the different engines.
    #     At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    #     designed to be invoked directly
    def after_create_user

        # create user details
        User::Detail.find_or_create_by({ user: self })

        # create an alias based on user name
        self.set_alias

    end


    # Initialize user settings and dependencies needed
    def after_confirmation_user
        return unless self.confirmed?

        self.settings.create_with(:value => false).find_or_create_by(:name => "mfa_enabled")
        self.settings.create_with(:value => :email).find_or_create_by(:name => "mfa_method")
    end

    def after_account_assignation
        return unless self.account

        Courier::One::Firebase::User.sync_user(self)
        Courier::Driver::Calendar.create_user_calendar(self, name: "Personal Calendar", default: true)
    end

end
