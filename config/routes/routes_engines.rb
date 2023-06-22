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

module RoutesEngines
    def self.extended(router)
        router.instance_exec do

            mount CloudKb::Engine          => "/kb"          if defined?(CloudKb)
            mount CloudOne::Engine         => "/one"         if defined?(CloudOne)
            mount CloudWord::Engine        => "/word"        if defined?(CloudWord)
            mount CloudWork::Engine        => "/work"        if defined?(CloudWork)
            mount CloudTeam::Engine        => "/team"        if defined?(CloudTeam)
            mount CloudBell::Engine        => "/bell"        if defined?(CloudBell)
            mount CloudHelp::Engine        => "/help"        if defined?(CloudHelp)
            mount CloudText::Engine        => "/text"        if defined?(CloudText)
            mount CloudTalk::Engine        => "/talk"        if defined?(CloudTalk)
            mount CloudTime::Engine        => "/time"        if defined?(CloudTime)
            mount CloudBooks::Engine       => "/books"       if defined?(CloudBooks)
            mount CloudAudit::Engine       => "/audit"       if defined?(CloudAudit)
            mount CloudLesli::Engine       => "/lesli"       if defined?(CloudLesli)
            mount CloudBabel::Engine       => "/babel"       if defined?(CloudBabel)
            mount CloudHouse::Engine       => "/house"       if defined?(CloudHouse)
            mount CloudFocus::Engine       => "/focus"       if defined?(CloudFocus)
            mount CloudSocial::Engine      => "/social"      if defined?(CloudSocial)
            mount CloudDriver::Engine      => "/driver"      if defined?(CloudDriver)
            mount CloudMailer::Engine      => "/mailer"      if defined?(CloudMailer)
            mount CloudPortal::Engine      => "/portal"      if defined?(CloudPortal)
            mount CloudRealty::Engine      => "/realty"      if defined?(CloudRealty)
            mount CloudThings::Engine      => "/things"      if defined?(CloudThings)
            mount CloudScraper::Engine     => "/scraper"     if defined?(CloudScraper)
            mount CloudStorage::Engine     => "/storage"     if defined?(CloudStorage)
            mount CloudInsights::Engine    => "/insights"    if defined?(CloudInsights)
            mount CloudProposal::Engine    => "/proposal"    if defined?(CloudProposal)
            mount CloudDevelopment::Engine => "/development" if defined?(CloudDevelopment)

            mount CloudShared::Engine      => "/shared"      if defined?(CloudShared)
            mount CloudDispatcher::Engine  => "/api"         if defined?(CloudDispatcher)
            mount CloudFederation::Engine  => "/cloud"       if defined?(CloudFederation)

        end
    end
end
