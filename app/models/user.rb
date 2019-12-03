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

    has_many    :notifications, class_name: 'CloudBell::Notification', foreign_key: 'users_id'
    has_many    :ticket_assignments, class_name: 'CloudHelp::Ticket::Assignment', as: :assignable
    has_many    :permissions

    has_one :detail, class_name: 'CloudLock::User::Detail', foreign_key: 'users_id', dependent: :delete, inverse_of: :user, autosave: true
    accepts_nested_attributes_for :detail

    def revoke_access
        update_attributes(active: false)
    end

    def ability
        @ability ||= Ability.new(self)
    end

    # used by CloudHelp::Ticket to show the name of the assignable (either user or team)
    def assignable_name
        email
    end

end
