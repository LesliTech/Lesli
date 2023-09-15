module Lesli
    class User < ApplicationLesliRecord

        include UserGuard
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
            #User::Detail.find_or_create_by({ user: self })

            # create an alias based on user name
            # defined in user extensions
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

            #Courier::One::Firebase::User.sync_user(self)
            #Courier::Driver::Calendar.create_user_calendar(self, name: "Personal Calendar", default: true)
        end


        def update_associated_services
            if saved_change_to_first_name? || saved_change_to_last_name? || saved_change_to_telephone?

                # defined in user extensions
                self.set_alias

                return 
                if defined? CloudOne

                    data = {
                        full_name: self.user.full_name,
                        telephone: self.telephone,
                    }

                    CloudOne::Firebase::User.update_data(self.user, data)

                end
            end
        end
    end
end
