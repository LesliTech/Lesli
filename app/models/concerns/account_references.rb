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

module AccountReferences
    extend ActiveSupport::Concern


    # initialize engines for new accounts
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
end
