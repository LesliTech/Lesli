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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
  
class Account < ApplicationRecord

    belongs_to :user, foreign_key: "users_id", optional: true

    has_many :users,        foreign_key: "accounts_id"
    has_many :roles,        foreign_key: "accounts_id"
    has_many :settings,     foreign_key: "accounts_id", class_name: "Account::Setting"
    has_many :locations,    foreign_key: "accounts_id"

    # core engines
    has_one :kb,     class_name: "CloudKb::Account",     foreign_key: "id"
    has_one :team,   class_name: "CloudTeam::Account",   foreign_key: "id"
    has_one :bell,   class_name: "CloudBell::Account",   foreign_key: "id"
    has_one :help,   class_name: "CloudHelp::Account",   foreign_key: "id"
    has_one :books,  class_name: "CloudBooks::Account",  foreign_key: "id"
    has_one :panel,  class_name: "CloudPanel::Account",  foreign_key: "id"
    has_one :house,  class_name: "CloudHouse::Account",  foreign_key: "id"
    has_one :focus,  class_name: "CloudFocus::Account",  foreign_key: "id"
    has_one :driver, class_name: "CloudDriver::Account", foreign_key: "id"

    after_create :initialize_account
    after_create :initialize_account_for_engines


    # account status
    enum status: [:registered, :active, :suspended]


    def initialize_account

        # settings initialize
        Rails.application.config.lesli_settings["account"]["settings"].each do |setting|
            self.settings.find_or_create_by({ name: setting[0], value: setting[1], account: self })
        end

        # create default roles
        account_roles = Rails.application.config.lesli_settings["account"]["security"]["roles"]
        account_roles.append "api"     # api-access only
        account_roles.append "guest"   # read-only
        account_roles.append "limited" # access only to user profile
        account_roles.prepend "admin"  # platform administrator role
        account_roles.prepend "owner"  # super admin role
        account_roles.uniq.each do |role_name|
            
            object_level_permission = 10
            object_level_permission = 1000 if role_name == "owner"
            object_level_permission = 1000 if role_name == "admin"

            @role = Role.create({
                account: self,
                detail_attributes: {
                    name: role_name,
                    object_level_permission: object_level_permission        
                }
            })

        end

    end

    def initialize_account_for_engines

        if defined? CloudKb
            if self.kb.blank?
                self.kb = CloudKb::Account.new
                self.kb.account = self
                self.kb.save!
            end
        end

        if defined? CloudTeam
            if self.team.blank?
                self.team = CloudTeam::Account.new
                self.team.account = self
                self.team.save!
            end
        end

        if defined? CloudBell
            if self.bell.blank?
                self.bell = CloudBell::Account.new
                self.bell.account = self
                self.bell.save!
            end
        end

        if defined? CloudDriver
            if self.driver.blank?
                self.driver = CloudDriver::Account.new
                self.driver.account = self
                self.driver.save!
            end
        end

        if defined? CloudFocus
            if self.focus.blank?
                self.focus = CloudFocus::Account.new
                self.focus.account = self
                self.focus.save!
            end
        end

        if defined? CloudHelp
            if self.help.blank?
                self.help = CloudHelp::Account.new
                self.help.account = self
                self.help.save!
            end
        end

        if defined? CloudHouse
            if self.house.blank?
                self.house = CloudHouse::Account.new
                self.house.account = self
                self.house.save!
                if defined? DeutscheLeibrenten
                    DeutscheLeibrenten::Account.initialize_workflows(self)
                end
            end
        end

    end

end
