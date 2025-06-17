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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module NavigationHelper

        # Prints a separator line
        def navigation_separator
            content_tag(:li) do
                content_tag(:hr)
            end
        end

        # Prints a html link inside a list item
        def navigation_item(path, label, icon = nil, reload: false)
            content_tag(:li, { class: "navbar-item"}) do
                navigation_link(path, label, icon, reload:reload)
            end
        end

        def navigation_link(path, label, icon = nil, reload: false)

            #content_tag(html_element, html_options) do
            link_to path, data: { turbo_frame: '_top' } do
                # print a simple menu item (without icon)
                concat content_tag(:span, label, class: "text iconless") unless icon

                # print a full menu item if icon was requested
                if icon
                    concat content_tag(:span, nil, class: icon)
                    concat content_tag(:span, label, class: "text")
                end
            end
        end

        def navigation_link_vue(path, label, icon = nil, reload: false)
            # default vue router links for single page applications
            html_element = "router-link"
            html_options = { to: path, 'active-class': "navigation-link-active" }

            # if reload is nedeed, we use a standard "a" tag
            if reload
                html_element = "a"
                html_options = { href: path }
            end

            content_tag(html_element, html_options) do
                # print a simple menu item (without icon)
                concat content_tag(:span, label, class: "text iconless") unless icon

                # print a full menu item if icon was requested
                if icon
                    concat content_tag(:span, nil, class: icon)
                    concat content_tag(:span, label, class: "text")
                end
            end
        end

        # ADMINISTRATION

        # 01.01 Admin engine
        def navigation_engine_admin(title: "Administration", subtitle: "Administration area.")
            return unless defined? LesliAdmin
            navigation_engine_item(title,subtitle,"admin",lesli_admin.root_path,controller_path.include?("lesli_admin"))
        end

        # 01.02 Team engine
        def navigation_engine_team(title: "Team", subtitle: "Human Resources Management")
            return unless defined? CloudTeam
            navigation_engine_item(title,subtitle,"team",cloud_team.root_path,controller_path.include?("cloud_team"))
        end

        # SALES & MARKETING

        # 02.04 House engine
        def navigation_engine_house(title: "House", subtitle: "cloud_house/house-logo.svg")
            return unless defined? CloudHouse
            navigation_engine_item(title,subtitle,"house",cloud_house.root_path,controller_path.include?("cloud_house"))
        end

        # 02.05 Mailer engine
        def navigation_engine_mailer(title: "Mailer", subtitle: "Email automation system")
            return unless defined? LesliMailer
            navigation_engine_item(title,subtitle,"mailer", lesli_mailer.root_path,controller_path.include?("lesli_mailer"))
        end

        # 02.08 Proposal engine
        def navigation_engine_proposal(title: "Proposal", subtitle: "cloud_proposal/proposal-logo.svg")
            return unless defined? CloudProposal
            navigation_engine_item(title,subtitle,"proposal",cloud_proposal.root_path,controller_path.include?("cloud_proposal"))
        end

        # PRODUCTIVITY & TEAMWORK

        # 03.01 Calendar engine
        def navigation_engine_calendar(title: "Calendar", subtitle: "Unified calendar app")
            return unless defined? LesliCalendar
            navigation_engine_item(title, subtitle, "calendar", lesli_calendar.root_path, controller_path.include?("lesli_calendar"))
        end

        # 03.03 Focus engine
        def navigation_engine_focus(title: "Tasks", subtitle: "Task Management")
            return unless defined? CloudFocus
            navigation_engine_item(title,subtitle,"focus",cloud_focus.root_path,controller_path.include?("cloud_focus"))
        end

        # 03.05 Letter engine
        def navigation_engine_letter(title: "Letter", subtitle: "Notes & Notebooks")
            return unless defined? LesliLetter
            navigation_engine_item(title,subtitle,"letter",lesli_letter.root_path,controller_path.include?("lesli_letter"))
        end

        # 03.06 Dashboard engine
        def navigation_engine_dashboard(title: "Dashboard", subtitle: "Smart business assistant")
            return unless defined? LesliDashboard
            navigation_engine_item(title,subtitle,"dashboard",lesli_dashboard.root_path,controller_path.include?("lesli_dashboard"))
        end

        # 03.07 Social engine
        def navigation_engine_social(title: "Social", subtitle: "Team social network")
            return unless defined? CloudSocial
            navigation_engine_item(title,subtitle,"social",cloud_social.root_path,controller_path.include?("cloud_social"))
        end

        # 03.08 Bell engine
        def navigation_engine_bell(title: "Notifications", subtitle: "Notifications & Announcements")
            return unless defined? LesliBell
            navigation_engine_item(title, subtitle, "bell", lesli_bell.root_path, controller_path.include?("lesli_bell"))
        end

        # 03.09 Time engine
        def navigation_engine_time(title: "Time managment", subtitle: "Track your time")
            return unless defined? CloudTime
            navigation_engine_item(title,subtitle,"time",cloud_time.root_path,controller_path.include?("cloud_time"))
        end

        # 03.10 Talk engine
        def navigation_engine_talk(title: "Talk", subtitle: "Real-time communication")
            return unless defined? CloudTalk
            navigation_engine_item(title,subtitle,"talk",cloud_talk.root_path,controller_path.include?("cloud_talk"))
        end

        # 03.11 Storage engine
        def navigation_engine_storage(title: "Storage", subtitle: "Cloud files management")
            return unless defined? CloudStorage
            navigation_engine_item(title,subtitle,"storage",cloud_storage.root_path,controller_path.include?("cloud_storage"))
        end

        # 03.12 Papers engine
        def navigation_engine_papers(title: "Papers", subtitle: "Smart Document Management")
            return unless defined? LesliPapers
            navigation_engine_item(title,subtitle,"papers",lesli_papers.root_path,controller_path.include?("lesli_papers"))
        end

        # FINANCE

        # 04.01 Books engine
        def navigation_engine_books(title: "Books", subtitle: "cloud_books/books-logo.svg")
            return unless defined? CloudBooks

            navigation_engine_item(title, subtitle, "books", cloud_books.root_path,
                                   controller_path.include?("cloud_books"))
        end

        # 04.03 Things engine
        def navigation_engine_things(title: "Things", subtitle: "cloud_things/things-logo.svg")
            return unless defined? CloudThings

            navigation_engine_item(title, subtitle, "things", cloud_things.root_path,
                                   controller_path.include?("cloud_things"))
        end

        # 04.05 Realty engine
        def navigation_engine_realty(title: "Realty", subtitle: "cloud_realty/realty-logo.svg")
            return unless defined? CloudRealty

            navigation_engine_item(title, subtitle, "realty", cloud_realty.root_path,
                                   controller_path.include?("cloud_realty"))
        end

        # ANALYTICS

        # 05.02 Audit engine 
        def navigation_engine_audit(title: "Audit", subtitle: "Activity, logs, security and more")
            return unless defined? LesliAudit
            navigation_engine_item(title, subtitle, "audit", lesli_audit.root_path, controller_path.include?("lesli_audit"))
        end

        
        # INTELLIGENCE

        # 06.06 Scraper engine
        def navigation_engine_scraper(title: "Scraper", subtitle: "Scraper")
            return unless defined? CloudScraper

            navigation_engine_item(title, subtitle, "scraper", cloud_scraper.root_path,
                                   controller_path.include?("cloud_scraper"))
        end

        # IT & HELP DESK

        # 07.01 Kb engine
        def navigation_engine_kb(title: "Kb", subtitle: "cloud_kb/kb-logo.svg")
            return unless defined? CloudKb

            navigation_engine_item(title, subtitle, "kb", cloud_kb.root_path, controller_path.include?("cloud_kb"))
        end

        # 07.02 Help engine
        def navigation_engine_support(title: "Support", subtitle: "Support Ticket System")
            return unless defined? LesliSupport
            navigation_engine_item(title, subtitle, "support", lesli_support.root_path, controller_path.include?("lesli_support"))
        end

        # 07.03 Portal engine
        def navigation_engine_portal(title: "Portal", subtitle: "cloud_portal/portal-logo.svg")
            return unless defined? CloudPortal

            navigation_engine_item(title, subtitle, "portal", cloud_portal.root_path,
                                   controller_path.include?("cloud_portal"))
        end

        # 07.05 Shared engine
        def navigation_engine_shared(title: "Shared", subtitle: "Shared & Open resources")
            return unless defined? CloudShared

            navigation_engine_item(title, subtitle, "shared", cloud_shared.root_path,
                                   controller_path.include?("cloud_shared"))
        end

        # SECURITY & PRIVACY

        # 08.01 Shield engine
        def navigation_engine_shield(title: "Shield", subtitle: "Authentication & Authorization")
            return unless defined? LesliShield
            navigation_engine_item(title, subtitle, "shield", lesli_shield.root_path, controller_path.include?("lesli_shield"))
        end

        # 08.02 Security engine
        def navigation_engine_security(title: "Security", subtitle: "Users Authorization Management.")
            return unless defined? LesliSecurity
            navigation_engine_item(title, subtitle, "security", lesli_security.root_path, controller_path.include?("lesli_security"))
        end


        # INTEGRATIONS

        # 09.01 Babel engine
        def navigation_engine_babel(title: "Babel", subtitle: "Translation Management System")
            return unless defined? LesliBabel

            navigation_engine_item(title, subtitle, "babel", lesli_babel.root_path,
                                   controller_path.include?("lesli_babel"))
        end

        # 09.02 Dispatcher engine
        def navigation_engine_dispatcher(title: "Dispatcher", subtitle: "cloud_dispatcher/dispatcher-logo.svg")
            return unless defined? CloudDispatcher

            navigation_engine_item(title, subtitle, "api", cloud_dispatcher.root_path,
                                   controller_path.include?("cloud_dispatcher"))
        end

        # 09.03 Federation engine
        def navigation_engine_federation(title: "Federation", subtitle: "cloud_federation/federation-logo.svg")
            return unless defined? CloudFederation

            navigation_engine_item(title, subtitle, "federation", cloud_federation.root_path,
                                   controller_path.include?("cloud_federation"))
        end

        # 09.04 One engine
        def navigation_engine_one(title: "One", subtitle: "Cloud Enterprise Resource Management")
            return unless defined? CloudOne

            navigation_engine_item(title, subtitle, "one", cloud_one.root_path,
                                   controller_path.include?("cloud_one"))
        end

        # 09.06 Development engine
        def navigation_engine_development(title: "Dev", subtitle: "Development notes")
            return unless defined? CloudDevelopment

            navigation_engine_item(title, subtitle, "development", cloud_development.root_path,
                                   controller_path.include?("cloud_development"))
        end

        private

        # build a html link for an engine path
        def navigation_engine_item(title, subtitle, icon, path, is_active)
            # get hidden modules if there are modules to hide
            modules_hidden = [] # Rails.application.config.lesli.dig(:modules_hidden) || []

            # stop rendering module navigation if need to hide the module
            return nil if modules_hidden.include?(path)

            # render module navigation item :)
            content_tag(:a, id: path.gsub("/",""), href: path, class: is_active ? "is-active" : nil, data: { turbo: false }) do
                lesli_svg("engine-#{icon}") << content_tag(:div) do
                    content_tag(:span, title) << content_tag(:p, subtitle)
                end
            end
        end
    end
end
