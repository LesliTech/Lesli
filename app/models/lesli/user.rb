module Lesli
    class User < ApplicationLesliRecord

        #include UserGuard
        include UserExtensions
        #include UserActivities
        #include UserPolyfill

        # users belongs to an account only... and must have a role
        belongs_to :account, optional: true

        # user details are saved on separate table
        has_one :detail, inverse_of: :user, autosave: true, dependent: :destroy
        accepts_nested_attributes_for :detail, update_only: true


        # users belongs to an account only... and must have a role
        belongs_to :account, optional: true

        validates :email, :presence => true


        # callbacks
        before_create :before_create_user
        after_create :after_create_user
        #after_create :after_confirmation_user, if: :confirmed?
        #after_create :after_account_assignation
        #after_update :update_associated_services


        # allow save duplicated users to execute callbacks
        def save(*args)
            super()
            rescue ActiveRecord::RecordNotUnique => error
        end


        # Before creating a user we make sure there is no capitalized email
        def before_create_user
            self.email = (self.email||"").downcase
        end


        def after_create_user

            # create user details
            #User::Detail.find_or_create_by({ user: self })

            # create an alias based on user name
            # defined in user extensions
            self.set_alias

        end
    end
end
