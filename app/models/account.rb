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

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class Account < ApplicationRecord

    belongs_to :user, foreign_key: 'users_id', optional: true

    has_many :users, foreign_key: 'accounts_id'
    has_many :settings, foreign_key: 'accounts_id'
    has_many :locations, foreign_key: 'accounts_id'

    # core engines
    has_one :kb,     class_name: "CloudKb::Account",     foreign_key: "id"
    has_one :team,   class_name: "CloudTeam::Account",   foreign_key: "id"
    has_one :bell,   class_name: "CloudBell::Account",   foreign_key: "id"
    has_one :lock,   class_name: "CloudLock::Account",   foreign_key: "id"
    has_one :help,   class_name: "CloudHelp::Account",   foreign_key: "id"
    has_one :books,  class_name: "CloudBooks::Account",  foreign_key: "id"
    has_one :panel,  class_name: "CloudPanel::Account",  foreign_key: "id"
    has_one :house,  class_name: "CloudHouse::Account",  foreign_key: "id"
    has_one :focus,  class_name: "CloudFocus::Account",  foreign_key: "id"
    has_one :driver, class_name: "CloudDriver::Account", foreign_key: "id"

    # dedicated custom engines
    #has_one :haus,  class_name: "CloudHaus::Account",  foreign_key: "id"

    after_create :create_engine_accounts

    def create_engine_accounts

        # settings initialize
        self.settings.find_or_create_by({ name: "date_format", value: "%Y.%m.%d", account: self })
        self.settings.find_or_create_by({ name: "date_format_full", value: "%a, %B %d, %Y", account: self })
        self.settings.find_or_create_by({ name: "date_time_format", value: "%Y.%m.%d %H:%M", account: self })
        self.settings.find_or_create_by({ name: "start_week_on", value: "monday", account: self })
        self.settings.find_or_create_by({ name: "theme", value: "deutsche-blue", account: self })
        self.settings.find_or_create_by({ name: "theme_variation", value: "standard", account: self })

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

        if defined? CloudLock
            if self.lock.blank?
                self.lock = CloudLock::Account.new
                self.lock.account = self
                self.lock.save!
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
                if defined? CloudHaus
                    CloudHaus::Account.initialize_workflows(self)
                end
            end
        end

    end

end
