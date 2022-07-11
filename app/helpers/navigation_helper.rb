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
        content_tag(:li) do
            content_tag("router-link exact", :to => path) do

                # print icon if for any icon family
                print_icon = (icon || rmi) ? true : false

                # print a simple menu item (without icon)
                concat content_tag(:span, label, :class => "text iconless") unless print_icon

                # print a full menu item if icon was requested
                if print_icon
                    concat content_tag("lesli-icon", nil, :id => icon, :class=> "icono") if icon
                    concat content_tag("span", nil, :class => [rmi, "icono"]) if rmi
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
        unless defined? CloudTeam
            return ""
        end
        navigation_engine_item title, subtitle, cloud_team.root_path, controller_path.include?("cloud_team")
    end

    # SALES & MARKETING

    # 02.04 House engine
    def navigation_engine_house title: "House", subtitle: "cloud_house/house-logo.svg"
        unless defined? CloudHouse
            return ""
        end
        navigation_engine_item title, subtitle, cloud_house.root_path, controller_path.include?("cloud_house")
    end

    # 02.05 Mailer engine
    def navigation_engine_mailer title: "Mailer", subtitle: "cloud_mailer/mailer-logo.svg"
        unless defined? CloudMailer
            return ""
        end
        navigation_engine_item title, subtitle, cloud_mailer.root_path, controller_path.include?("cloud_mailer")
    end

    # 02.08 Proposal engine
    def navigation_engine_proposal title: "Proposal", subtitle: "cloud_proposal/proposal-logo.svg"
        unless defined? CloudProposal
            return ""
        end
        navigation_engine_item title, subtitle, cloud_proposal.root_path, controller_path.include?("cloud_proposal")
    end

    # PRODUCTIVITY & TEAMWORK

    # 03.01 Driver engine
    def navigation_engine_driver title: "Driver", subtitle: "cloud_driver/driver-logo.svg"
        unless defined? CloudDriver
            return ""
        end
        return navigation_engine_item title, subtitle, cloud_driver.root_path, controller_path.include?("cloud_driver")
    end

    # 03.02 Work engine
    def navigation_engine_work title: "Work", subtitle: "cloud_work/work-logo.svg"
        unless defined? CloudWork
            return ""
        end
        return navigation_engine_item title, subtitle, cloud_work.root_path, controller_path.include?("cloud_work")
    end

    # 03.03 Focus engine
    def navigation_engine_focus title: "Tasks", subtitle: "cloud_focus/focus-logo.svg"
        unless defined? CloudFocus
            return ""
        end
        return navigation_engine_item title, subtitle, cloud_focus.root_path, controller_path.include?("cloud_focus")
    end

    # 03.05 Text engine
    def navigation_engine_text title: "Text", subtitle: "cloud_text/text-logo.svg"
        unless defined? CloudText
            return ""
        end
        navigation_engine_item title, subtitle, cloud_text.root_path, controller_path.include?("cloud_text")
    end

    # 03.08 Bell engine
    def navigation_engine_bell title: "Notifications", subtitle: "Announcements and notifications"
        unless defined? CloudBell
            return ""
        end
        navigation_engine_item(title, subtitle, "bell", cloud_bell.root_path, controller_path.include?("cloud_bell"))
    end

    # 03.10 Talk engine
    def navigation_engine_talk title: "Talk", subtitle: "cloud_talk/talk-logo.svg"
        unless defined? CloudTalk
            return ""
        end
        navigation_engine_item title, subtitle, cloud_talk.root_path, controller_path.include?("cloud_talk")
    end

    # 03.11 Storage engine
    def navigation_engine_storage title: "Storage", subtitle: "cloud_storage/storage-logo.svg"
        unless defined? CloudStorage
            return ""
        end
        navigation_engine_item title, subtitle, cloud_storage.root_path, controller_path.include?("cloud_storage")
    end
    
    # FINANCE

    # 04.01 Books engine
    def navigation_engine_books title: "Books", subtitle: "cloud_books/books-logo.svg"
        unless defined? CloudBooks
            return ""
        end
        navigation_engine_item title, subtitle, cloud_books.root_path, controller_path.include?("cloud_books")
    end

    # 04.03 Things engine
    def navigation_engine_things title: "Things", subtitle: "cloud_things/things-logo.svg"
        unless defined? CloudThings
            return ""
        end
        navigation_engine_item title, subtitle, cloud_things.root_path, controller_path.include?("cloud_things")
    end

    # 04.05 Realty engine
    def navigation_engine_realty title: "Realty", subtitle: "cloud_realty/realty-logo.svg"
        unless defined? CloudRealty
            return ""
        end
        navigation_engine_item title, subtitle, cloud_realty.root_path, controller_path.include?("cloud_realty")
    end 


    # ANALYTICS

    # 05.04 Insights engine
    def navigation_engine_insights title: "Insights", subtitle: "cloud_insights/insights-logo.svg"
        unless defined? CloudInsights
            return ""
        end
        navigation_engine_item title, subtitle, cloud_insights.root_path, controller_path.include?("cloud_insights")
    end


    # INTELLIGENCE


    # IT & HELP DESK

    # 07.01 Kb engine
    def navigation_engine_kb title: "Kb", subtitle: "cloud_kb/kb-logo.svg"
        unless defined? CloudKb
            return ""
        end
        navigation_engine_item title, subtitle, cloud_kb.root_path, controller_path.include?("cloud_kb")
    end

    # 07.02 Help engine
    def navigation_engine_help title: "Help", subtitle: "Tickets, SLAs, Reports"
        unless defined? CloudHelp
            return ""
        end
        navigation_engine_item(title, subtitle, "help", cloud_help.root_path, controller_path.include?("cloud_help"))
    end

    # 07.03 Portal engine
    def navigation_engine_portal title: "Portal", subtitle: "cloud_portal/portal-logo.svg"
        unless defined? CloudPortal
            return ""
        end
        navigation_engine_item title, subtitle, cloud_portal.root_path, controller_path.include?("cloud_portal")
    end

    # 07.05 Shared engine
    def navigation_engine_shared title: "Shared", subtitle: "cloud_shared/shared-logo.svg"
        unless defined? CloudShared
            return ""
        end
        navigation_engine_item title, subtitle, cloud_shared.root_path, controller_path.include?("cloud_shared")
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
            navigation_engine_item title, subtitle, "babel", cloud_babel.root_path, controller_path.include?("cloud_babel")
        end
    end

    # 09.02 Dispatcher engine
    def navigation_engine_dispatcher title: "Dispatcher", subtitle: "cloud_dispatcher/dispatcher-logo.svg"
        unless defined? CloudDispatcher
            return ""
        end
        navigation_engine_item title, subtitle, cloud_dispatcher.root_path, controller_path.include?("cloud_dispatcher")
    end

    # 09.03 Federation engine
    def navigation_engine_federation title: "Federation", subtitle: "cloud_federation/federation-logo.svg"
        unless defined? CloudFederation
            return ""
        end
        navigation_engine_item title, subtitle, cloud_federation.root_path, controller_path.include?("cloud_federation")
    end

    # 09.04 One engine
    def navigation_engine_one title: "One", subtitle: "cloud_one/one-logo.svg"
        unless defined? CloudOne
            return ""
        end
        navigation_engine_item title, subtitle, cloud_one.root_path, controller_path.include?("cloud_one")
    end

    # 09.06 Development engine
    def navigation_engine_development title: "Dev", subtitle: "Development notes"
        unless defined? CloudDevelopment
            return ""
        end
        navigation_engine_item title, subtitle, "dev", cloud_development.root_path, controller_path.include?("cloud_development")
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
            lesli_icon(icon, "cloud") << content_tag(:div) do 
                content_tag(:span, title) << content_tag(:p, subtitle)
            end
        end

    end

end
