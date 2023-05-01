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
