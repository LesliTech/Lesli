=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Account < ApplicationRecord
    include AccountEngines


    # accounts always belongs to a user
    belongs_to :user, optional: true


    # account resources
    has_many :users
    has_many :roles
    has_many :files
    has_many :cronos
    has_many :settings
    has_many :locations
    has_many :descriptors
    has_many :activities, class_name: "Account::Activity"
    has_many :currencies, class_name: "Account::Currency"
    has_many :logs


    # standard engines
    has_one :kb,         class_name: "CloudKb::Account",         foreign_key: "id"
    has_one :one,        class_name: "CloudOne::Account",        foreign_key: "id"
    has_one :team,       class_name: "CloudTeam::Account",       foreign_key: "id"
    has_one :bell,       class_name: "CloudBell::Account",       foreign_key: "id"
    has_one :help,       class_name: "CloudHelp::Account"
    has_one :text,       class_name: "CloudText::Account",       foreign_key: "id"
    has_one :talk,       class_name: "CloudTalk::Account",       foreign_key: "id"
    has_one :time,       class_name: "CloudTime::Account",       foreign_key: "id"
    has_one :work,       class_name: "CloudWork::Account",       foreign_key: "id"
    has_one :word,       class_name: "CloudWord::Account",       foreign_key: "id"
    has_one :audit,      class_name: "CloudAudit::Account" #,      foreign_key: "id"
    has_one :lesli,      class_name: "CloudLesli::Account",      foreign_key: "id"
    has_one :books,      class_name: "CloudBooks::Account",      foreign_key: "id"
    has_one :house,      class_name: "CloudHouse::Account",      foreign_key: "id"
    has_one :focus,      class_name: "CloudFocus::Account",      foreign_key: "id"
    has_one :driver,     class_name: "CloudDriver::Account",     foreign_key: "id"
    has_one :mailer,     class_name: "CloudMailer::Account",     foreign_key: "id"
    has_one :things,     class_name: "CloudThings::Account",     foreign_key: "id"
    has_one :shared,     class_name: "CloudShared::Account",     foreign_key: "id"
    has_one :portal,     class_name: "CloudPortal::Account",     foreign_key: "id"
    has_one :social,     class_name: "CloudSocial::Account",     foreign_key: "id"
    has_one :storage,    class_name: "CloudStorage::Account",    foreign_key: "id"
    has_one :proposal,   class_name: "CloudProposal::Account",   foreign_key: "id"
    has_one :dispatcher, class_name: "CloudDispatcher::Account", foreign_key: "id"
    

    # initializers for new accounts
    after_create :initialize_account
    after_create :initialize_engines
    after_create :initialize_instance
    after_create :initialize_settings


    # account statuses
    enum status: [
        :registered,
        :onboarding,
        :active,
        :suspended
    ]


    # company region (GDPR)
    enum region: {
        latin_america: "latin_america",
        united_states: "united_states",
        european_union: "european_union"
    }


    def initialize_account

        # create initial descriptors
        descriptor_owner = self.descriptors.find_or_create_by(name: "owner")
        descriptor_sysadmin = self.descriptors.find_or_create_by(name: "sysadmin")
        descriptor_profile = self.descriptors.find_or_create_by(name: "profile")


        # create default roles for the new account
        owner = self.roles.create({ name: "owner", active: true, object_level_permission: 2147483647 })

        # platform administrator role
        sysadmin = self.roles.create({ name: "sysadmin", active: true, object_level_permission: 100000 })

        # access only to user profile
        limited = self.roles.create({ name: "limited", active: true, object_level_permission: 10, path_default: "/administration/profile" })


        # assign descriptors with appropriate privileges
        owner.descriptors.create(:descriptor => descriptor_owner)
        sysadmin.descriptors.create(:descriptor => descriptor_sysadmin)
        limited.descriptors.create(:descriptor => descriptor_profile)
    end


    def initialize_instance

        # Every instance (builder module) is loaded into the platform using the same
        # name of the engine
        instance = Rails.application.config.lesli.dig(:instance, :name)

        # Build an account class base on instance (engine) name
        # Example: LesliCloud::Account - this is a standard name
        instance_account_klass = "#{instance}::Account".safe_constantize

        # If instance account class exists
        instance_account_klass.find_or_create_by(:id => self.id) if instance_account_klass

    end


    def initialize_settings
        Account::Setting.initialize_data(self)
    end


    def options(current_user, query)
        # countries = Account::Location.list(current_user, {
        #     :filters => { :type => "country" }
        # }).map { |country| { id: country.id, name: country.name } }

        regions = Account.regions.map { |key, value| { key: key, value: value } }

        time_zones = ActiveSupport::TimeZone::MAPPING.map { |key, value| { value: value, text: value } }

        return {
            regions: regions,
            #countries: countries,
            time_zones: time_zones.uniq { |time_zone| [time_zone[:value], time_zone[:text]] },
            days_into_week: DateAndTime::Calculations::DAYS_INTO_WEEK.map { |day, value| { value: day, text: I18n.t("core.shared.view_text_day_#{day}") } },
        }
    end

end
