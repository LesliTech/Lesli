=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   ldonis & Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description User model. Establishes entities relations and enables devise modules

=end
class User < ApplicationRecord
    acts_as_paranoid
    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable
    
    belongs_to  :account , foreign_key: 'accounts_id', optional: true
    belongs_to  :role, class_name: 'CloudLock::Role', foreign_key:'cloud_lock_roles_id', optional: true
    
    has_one :detail, class_name: 'CloudLock::User::Detail', foreign_key: 'users_id', dependent: :delete, inverse_of: :user, autosave: true
    accepts_nested_attributes_for :detail

    # remove this
    has_many    :notifications, class_name: 'CloudBell::Notification', foreign_key: 'users_id'

    after_create :check_user

=begin
@return [String] The name of this user.
@description Retrieves and returns the name of the user depending on the available information.
    The name can be a full name (first and last names), just the first name, or, in case the information
    is not available, the email. This method currently is available if the the CloudLock engine exists,
    otherwise, it returns *nil*
@example
    my_user = current_user
    puts my_user.name # can print John Doe
    other_user = User.last
    puts other_user.name # can print jane.smith@email.com
=end
    def name
        if defined? CloudLock
            unless detail.blank?
                unless detail.first_name.blank? && detail.last_name.blank?
                    return [detail.first_name, detail.last_name].join(' ') 
                end
                return detail.first_name unless detail.first_name.blank? 
            end
        end
        return email
    end

=begin
@return [void]
@description Sets this user as inactive and removes complete access to the platform from them
@example
    old_user = User.last
    old_user.revoke_access
=end
    def revoke_access
        update_attributes(active: false)
    end

    private 

=begin
@return [void]
@description After creating a user, creates the necessary resources for them to access the different engines.
    At the current time, it only creates a default calendar. This is an *after_create* method, and is not
    designed to be invoked directly
@example
    new_user = User.create(
        email: 'john.doe@mail.com',
        password: '1234567890',
        password_confirmation: '1234567890'
    )
    # At this point, check_user will be invoked automatically
=end
    def check_user
        if defined? CloudDriver
            self.account.driver.calendars.create({
                detail_attributes: {
                    name: self.name,
                    default: true
                }
            })
        end
    end

=begin
@return [Ability] All permissions this user has
@description Returns the permissions this user has as a *CanCan:Ability*
@example
    my_permissions = self.ability
=end
    def ability
        @ability ||= Ability.new(self)
    end

end
