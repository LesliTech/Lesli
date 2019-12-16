class User < ApplicationRecord
    acts_as_paranoid
    devise  :database_authenticatable, 
            :registerable, 
            :recoverable, 
            :rememberable, 
            :trackable, 
            :validatable,
            :confirmable

    after_save :check_accounts    
    
    belongs_to  :account , foreign_key: 'accounts_id', optional: true
    belongs_to  :role, class_name: 'CloudLock::Role', foreign_key:'cloud_lock_roles_id', optional: true
    
    has_many    :notifications, class_name: 'CloudBell::Notification', foreign_key: 'users_id'
    has_many    :ticket_assignments, class_name: 'CloudHelp::Ticket::Assignment', foreign_key: 'users_id'
    has_many    :permissions

    has_one :detail, class_name: 'CloudLock::User::Detail', foreign_key: 'users_id', dependent: :delete, inverse_of: :user, autosave: true
    accepts_nested_attributes_for :detail

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

    def revoke_access
        update_attributes(active: false)
    end

    def ability
        @ability ||= Ability.new(self)
    end

    def check_accounts
        if defined? CloudTeam
            if self.account.team.blank?
                self.account.team = CloudTeam::Account.new
                self.account.team.account = self.account
                self.account.team.save!
            end
        end
        if defined? CloudDriver
            if self.account.driver.blank?
                self.account.driver = CloudDriver::Account.new
                self.account.driver.account = self.account
                self.account.driver.save!
            end
        end
        if defined? CloudBell
            if self.account.bell.blank?
                self.account.bell = CloudBell::Account.new
                self.account.bell.account = self.account
                self.account.bell.save!
            end
        end
    end

end
