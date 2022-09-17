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

module NavigationHelper

    # Prints a html link inside a list item
    def navigation_item(link_path)
        class_name = request.original_fullpath.include?(link_path) ? "is-active" : nil
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    # Prints a vue router link inside a list item
    def navigation_vue_item(link_path)
        content_tag(:li) do
            content_tag("router-link exact", :to => link_path) do
                yield
            end
        end
    end

    # Prints a link for lesli-navigation
    def navigation_lesli_item(path, label, icon=nil, rmi:nil)
        rmi=icon
        content_tag(:li) do
            content_tag("router-link exact", :to => path) do

                # print a simple menu item (without icon)
                concat content_tag(:span, label, :class => "text iconless") unless icon

                # print a full menu item if icon was requested
                if icon
                    #concat content_tag("lesli-icon", nil, :id => icon, :class=> "icono") if icon
                    concat content_tag("span", nil, :class => [rmi, "icono"]) #if rmi
                    concat content_tag(:span, label, :class => "text") 
                end 
                
            end
        end
    end 

    # Prints a separator line
    def navigation_separator
        content_tag(:li) do 
            content_tag(:hr)
        end 
    end

    # 00.00 System administration
    def navigation_administration title: "Administration", subtitle: "Users, privileges, access roles."
        navigation_engine_item(title, subtitle, "administration", main_app.account_path, 
            ["accounts", "users"].include?(controller_path)
        )
    end

    # ADMINISTRATION

    # 01.01 Team engine
    def navigation_engine_team title: "Team", subtitle: "cloud_team/team-logo.svg"
        if defined? CloudTeam
            navigation_engine_item(title, subtitle, "team", cloud_team.root_path, controller_path.include?("cloud_team"))
        end
    end

    # SALES & MARKETING

    # 02.04 House engine
    def navigation_engine_house title: "House", subtitle: "cloud_house/house-logo.svg"
        if defined? CloudHouse
            navigation_engine_item(title, subtitle, "house", cloud_house.root_path, controller_path.include?("cloud_house"))
        end
    end

    # 02.05 Mailer engine
    def navigation_engine_mailer title: "Mailer", subtitle: "cloud_mailer/mailer-logo.svg"
        if defined? CloudMailer
            navigation_engine_item(title, subtitle, "mailer", cloud_mailer.root_path, controller_path.include?("cloud_mailer"))
        end
    end

    # 02.08 Proposal engine
    def navigation_engine_proposal title: "Proposal", subtitle: "cloud_proposal/proposal-logo.svg"
        if defined? CloudProposal
            navigation_engine_item(title, subtitle, "proposal", cloud_proposal.root_path, controller_path.include?("cloud_proposal"))
        end
    end

    # PRODUCTIVITY & TEAMWORK

    # 03.01 Driver engine
    def navigation_engine_driver title: "Driver", subtitle: "Calendar"
        if defined? CloudDriver
            navigation_engine_item(title, subtitle, "driver", cloud_driver.root_path, controller_path.include?("cloud_driver"))
        end
    end

    # 03.02 Work engine
    def navigation_engine_work title: "Work", subtitle: "cloud_work/work-logo.svg"
        if defined? CloudWork
            navigation_engine_item(title, subtitle, "work", cloud_work.root_path, controller_path.include?("cloud_work"))
        end
    end

    # 03.03 Focus engine
    def navigation_engine_focus title: "Tasks", subtitle: "cloud_focus/focus-logo.svg"
        if defined? CloudFocus
            navigation_engine_item(title, subtitle, "focus", cloud_focus.root_path, controller_path.include?("cloud_focus"))
        end
    end

    # 03.05 Text engine
    def navigation_engine_text title: "Text", subtitle: "cloud_text/text-logo.svg"
        if defined? CloudText
            navigation_engine_item(title, subtitle, "text", cloud_text.root_path, controller_path.include?("cloud_text"))
        end
    end

    # 03.08 Bell engine
    def navigation_engine_bell title: "Notifications", subtitle: "Announcements and notifications"
        if defined? CloudBell
            navigation_engine_item(title, subtitle, "bell", cloud_bell.root_path, controller_path.include?("cloud_bell"))
        end
    end

    # 03.10 Talk engine
    def navigation_engine_talk title: "Talk", subtitle: "Real-time communication"
        if defined? CloudTalk
            navigation_engine_item(title, subtitle, "talk", cloud_talk.root_path, controller_path.include?("cloud_talk"))
        end
    end

    # 03.11 Storage engine
    def navigation_engine_storage title: "Storage", subtitle: "cloud_storage/storage-logo.svg"
        if defined? CloudStorage
            navigation_engine_item(title, subtitle, "storage", cloud_storage.root_path, controller_path.include?("cloud_storage"))
        end
    end
    
    # FINANCE

    # 04.01 Books engine
    def navigation_engine_books title: "Books", subtitle: "cloud_books/books-logo.svg"
        if defined? CloudBooks
            navigation_engine_item(title, subtitle, "books", cloud_books.root_path, controller_path.include?("cloud_books"))
        end
    end

    # 04.03 Things engine
    def navigation_engine_things title: "Things", subtitle: "cloud_things/things-logo.svg"
        if defined? CloudThings
            navigation_engine_item(title, subtitle, "things", cloud_things.root_path, controller_path.include?("cloud_things"))
        end
    end

    # 04.05 Realty engine
    def navigation_engine_realty title: "Realty", subtitle: "cloud_realty/realty-logo.svg"
        if defined? CloudRealty
            navigation_engine_item(title, subtitle, "realty", cloud_realty.root_path, controller_path.include?("cloud_realty"))
        end
    end 


    # ANALYTICS

    # 05.04 Insights engine
    def navigation_engine_insights title: "Insights", subtitle: "cloud_insights/insights-logo.svg"
        if defined? CloudInsights
            navigation_engine_item(title, subtitle, "insights", cloud_insights.root_path, controller_path.include?("cloud_insights"))
        end
    end


    # INTELLIGENCE


    # IT & HELP DESK

    # 07.01 Kb engine
    def navigation_engine_kb title: "Kb", subtitle: "cloud_kb/kb-logo.svg"
        if defined? CloudKb
            navigation_engine_item(title, subtitle, "kb", cloud_kb.root_path, controller_path.include?("cloud_kb"))
        end
    end

    # 07.02 Help engine
    def navigation_engine_help title: "Help", subtitle: "Tickets, SLAs, Reports"
        if defined? CloudHelp
            navigation_engine_item(title, subtitle, "help", cloud_help.root_path, controller_path.include?("cloud_help"))
        end
    end

    # 07.03 Portal engine
    def navigation_engine_portal title: "Portal", subtitle: "cloud_portal/portal-logo.svg"
        if defined? CloudPortal
            navigation_engine_item(title, subtitle, "portal", cloud_portal.root_path, controller_path.include?("cloud_portal"))
        end
    end

    # 07.05 Shared engine
    def navigation_engine_shared title: "Shared", subtitle: "cloud_shared/shared-logo.svg"
        if defined? CloudShared
            navigation_engine_item(title, subtitle, "shared", cloud_shared.root_path, controller_path.include?("cloud_shared"))
        end
    end


    # SECURITY & PRIVACY

    # 08.03 Audit engine
    def navigation_engine_audit title: "Admin audit", subtitle: "Activity, logs, security and more"
        if defined? CloudAudit
            navigation_engine_item(title, subtitle, "audit", cloud_audit.root_path, controller_path.include?("cloud_audit"))
        end
    end

    
    # INTEGRATIONS

    # 09.01 Babel engine
    def navigation_engine_babel title: "Babel", subtitle: "Translations"
        if defined? CloudBabel
            navigation_engine_item(title, subtitle, "babel", cloud_babel.root_path, controller_path.include?("cloud_babel"))
        end
    end

    # 09.02 Dispatcher engine
    def navigation_engine_dispatcher title: "Dispatcher", subtitle: "cloud_dispatcher/dispatcher-logo.svg"
        if defined? CloudDispatcher
            navigation_engine_item(title, subtitle, "api", cloud_dispatcher.root_path, controller_path.include?("cloud_dispatcher"))
        end
    end

    # 09.03 Federation engine
    def navigation_engine_federation title: "Federation", subtitle: "cloud_federation/federation-logo.svg"
        if defined? CloudFederation
            navigation_engine_item(title, subtitle, "federation", cloud_federation.root_path, controller_path.include?("cloud_federation"))
        end
    end

    # 09.04 One engine
    def navigation_engine_one title: "One", subtitle: "Cloud Enterprise Resource Management"
        if defined? CloudOne
            navigation_engine_item(title, subtitle, "one", cloud_one.root_path, controller_path.include?("cloud_one"))
        end
    end

    # 09.06 Development engine
    def navigation_engine_development title: "Dev", subtitle: "Development notes"
        if defined? CloudDevelopment
            navigation_engine_item(title, subtitle, "dev", cloud_development.root_path, controller_path.include?("cloud_development"))
        end
    end

    # DEPRECATED
    def nav_link(link_path)
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    private

    # build a html link for an engine path
    def navigation_engine_item title, subtitle, icon, path, is_active = false

        # get hidden modules if there are modules to hide
        modules_hidden = Rails.application.config.lesli.dig(:modules_hidden) || []

        # stop rendering module navigation if need to hide the module
        return nil if modules_hidden.include?(path)

        # render module navigation item :) 
        content_tag(:a, :href => path, :class => is_active ? "is-active": nil) do
            lesli_svg("cloud-#{icon}") << content_tag(:div) do 
                content_tag(:span, title) << content_tag(:p, subtitle)
            end
        end

    end

end
