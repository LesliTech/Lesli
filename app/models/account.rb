=begin

Copyright (c) 2020, all rights reserved.

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

class Account < ApplicationRecord

    belongs_to :user, foreign_key: "users_id", optional: true

    has_many :users,            foreign_key: "accounts_id"
    has_many :roles,            foreign_key: "accounts_id"
    has_many :files,            foreign_key: "accounts_id"
    has_many :cronos,           foreign_key: "accounts_id"
    has_many :issues,           foreign_key: "accounts_id", class_name: "Account::Issue"
    has_many :settings,         foreign_key: "accounts_id", class_name: "Account::Setting"
    has_many :locations,        foreign_key: "accounts_id"
    has_many :activities,       foreign_key: "accounts_id", class_name: "Account::Activity"
    has_many :currencies,       foreign_key: "accounts_id", class_name: "Account::Currency"
    has_many :integrations,     foreign_key: "accounts_id"
    has_many :role_descriptors, foreign_key: "accounts_id", class_name: "RoleDescriptor"
    has_many :descriptors,      foreign_key: "accounts_id"

    has_one :template, class_name: "Template", foreign_key: "accounts_id"

    # core engines
    has_one :kb,         class_name: "CloudKb::Account",         foreign_key: "id"
    has_one :one,        class_name: "CloudOne::Account",        foreign_key: "id"
    has_one :team,       class_name: "CloudTeam::Account",       foreign_key: "id"
    has_one :bell,       class_name: "CloudBell::Account",       foreign_key: "id"
    has_one :help,       class_name: "CloudHelp::Account",       foreign_key: "id"
    has_one :text,       class_name: "CloudText::Account",       foreign_key: "id"
    has_one :talk,       class_name: "CloudTalk::Account",       foreign_key: "id"
    has_one :time,       class_name: "CloudTime::Account",       foreign_key: "id"
    has_one :work,       class_name: "CloudWork::Account",       foreign_key: "id"
    has_one :audit,      class_name: "CloudAudit::Account",      foreign_key: "id"
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
    has_one :scraper,    class_name: "CloudScraper::Account",    foreign_key: "id"
    has_one :proposal,   class_name: "CloudProposal::Account",   foreign_key: "id"
    has_one :dispatcher, class_name: "CloudDispatcher::Account", foreign_key: "id"
    has_one :storage,    class_name: "CloudStorage::Account",    foreign_key: "id"
    has_one :realty,     class_name: "CloudRealty::Account",     foreign_key: "id"
    has_one :scraper,    class_name: "CloudScraper::Account",     foreign_key: "id"
    has_one :word,       class_name: "CloudWord::Account",       foreign_key: "id"

    after_create :initialize_account
    after_create :initialize_engines
    after_create :initialize_instance
    after_create :initialize_settings

    # account status
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

        #create template reference
        if self.template.blank?
            self.template = Template.new
            self.template.account = self
            self.template.save!
        end

        # create initial descriptors 
        self.descriptors.find_or_create_by(name: "owner")
        self.descriptors.find_or_create_by(name: "sysadmin")
        self.descriptors.find_or_create_by(name: "profile")

        # create default roles
        account_roles = Rails.application.config.lesli[:security][:roles] || []
        account_roles.append "limited"   # access only to user profile
        account_roles.prepend "sysadmin" # platform administrator role
        account_roles.prepend "owner"    # super admin role
        account_roles.uniq.each do |role_name|

            object_level_permission = 10
            object_level_permission = 2147483647 if role_name == "owner"
            object_level_permission = 1000 if role_name == "sysadmin"

            role = Role.create({
                account: self,
                name: role_name,
                active: true,
                object_level_permission: object_level_permission
            })

        end

        Account::LocationService.new(self).set_locations

    end

    def initialize_engines

        if defined? CloudDispatcher
            if self.dispatcher.blank?
                self.dispatcher = CloudDispatcher::Account.new
                self.dispatcher.account = self
                self.dispatcher.save!
            end
        end

        if defined? CloudKb
            if self.kb.blank?
                self.kb = CloudKb::Account.new
                self.kb.account = self
                self.kb.save!
            end
        end

        if defined? CloudOne
            if self.one.blank?
                self.one = CloudOne::Account.new
                self.one.account = self
                self.one.save!
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

        if defined? CloudMailer
            if self.mailer.blank?
                self.mailer = CloudMailer::Account.new
                self.mailer.account = self
                self.mailer.save!
            end
        end

        if defined? CloudText
            if self.text.blank?
                self.text = CloudText::Account.new
                self.text.account = self
                self.text.save!
            end
        end

        if defined? CloudTalk
            if self.talk.blank?
                self.talk = CloudTalk::Account.new
                self.talk.account = self
                self.talk.save!
            end
        end

        if defined? CloudStorage
            if self.storage.blank?
                self.storage = CloudStorage::Account.new
                self.storage.account = self
                self.storage.save!
            end
        end

        if defined? CloudBooks
            if self.books.blank?
                self.books = CloudBooks::Account.new
                self.books.account = self
                self.books.save!
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

        if defined? CloudAudit
            if self.audit.blank?
                self.audit = CloudAudit::Account.new
                self.audit.account = self
                self.audit.save!
            end
        end

        if defined? CloudThings
            if self.things.blank?
                self.things = CloudThings::Account.new
                self.things.account = self
                self.things.save!
            end
        end

        if defined? CloudProposal
            if self.proposal.blank?
                self.proposal = CloudProposal::Account.new
                self.proposal.account = self
                self.proposal.save!
            end
        end

        if defined? CloudRealty
            if self.realty.blank?
                self.realty = CloudRealty::Account.new
                self.realty.account = self
                self.realty.save!
            end
        end

        if defined? CloudLesli
            if self.lesli.blank?
                self.lesli = CloudLesli::Account.new
                self.lesli.account = self
                self.lesli.save!
            end
        end

        if defined? CloudShared
            if self.shared.blank?
                self.shared = CloudShared::Account.new
                self.shared.account = self
                self.shared.save!
            end
        end

        if defined? CloudPortal
            if self.portal.blank?
                self.portal = CloudPortal::Account.new
                self.portal.account = self
                self.portal.save!
            end
        end

        if defined? CloudWork
            if self.work.blank?
                self.work = CloudWork::Account.new
                self.work.account = self
                self.work.save!
            end
        end

        if defined? CloudWord
            if self.word.blank?
                self.word = CloudWord::Account.new
                self.word.account = self
                self.word.save!
            end
        end

        if defined? CloudSocial
            if self.social.blank?
                self.social = CloudSocial::Account.new
                self.social.account = self
                self.social.save!
            end
        end

        if defined? CloudScraper
            if self.scraper.blank?
                self.scraper = CloudScraper::Account.new
                self.scraper.account = self
                self.scraper.save!
            end
        end

        if defined? CloudTime
            if self.time.blank?
                self.time = CloudTime::Account.new
                self.time.account = self
                self.time.save!
            end
        end

    end

    def initialize_instance

        # Every instance (builder module) is loaded into the platform using the same
        # name of the engine
        instance = Rails.application.config.lesli[:instance][:name]


        # Build an account class base on instance (engine) name
        # Example: LesliCloud::Account - this is a standard name
        instance_account_klass = "#{instance}::Account".safe_constantize


        # If instance account class exists
        if instance_account_klass

            instance_account_klass.find_or_create_by(:id => self.id)

        end

    end

    def initialize_settings
        Account::Setting.initialize_data(self)
    end

    def options(current_user, query)
        countries = Account::Location.list(current_user, {
            :filters => { :type => "country" }
        }).map { |country| { id: country.id, name: country.name } }

        regions = Account.regions.map { |key, value| { key: key, value: value } }

        time_zones = ActiveSupport::TimeZone::MAPPING.map { |key, value| { value: value, text: value } }

        return {
            regions: regions,
            countries: countries,
            time_zones: time_zones.uniq { |time_zone| [time_zone[:value], time_zone[:text]] },
            days_into_week: DateAndTime::Calculations::DAYS_INTO_WEEK.map { |day, value| { value: day, text: I18n.t("core.shared.view_text_day_#{day}") } },
        }
    end


    # Especific associations for dedicated instances
    # This modules does not belongs to Lesli core, thats why we have the association here
    has_one :mitwerken, class_name: "MitwerkenCloud::Account", foreign_key: "id"
end
