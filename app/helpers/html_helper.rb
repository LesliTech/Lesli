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

module HtmlHelper

    def navigation_item(link_path)
        class_name = request.original_fullpath.include?(link_path) ? "is-active" : nil
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    def navigation_vue_item(link_path)
        content_tag(:li) do
            content_tag("router-link", :to => link_path) do
                yield
            end
        end
    end

    def navigation_engine_item text, icon_path, path, is_active = false
        content_tag(:a, :href => path, :class => is_active ? "is-active": nil) do
            image_tag(icon_path) +
                    content_tag(:span, text)
        end
    end

    # 00.00 System administration
    def navigation_administration text: "Admin", icon_path: "icons/administration-logo.svg"
        navigation_engine_item text, icon_path, main_app.account_path
    end


    # ADMINISTRATION

    # 01.01 Team engine
    def navigation_engine_team text: "Team", icon_path: "cloud_team/team-logo.svg"
        unless defined? CloudTeam
            return ""
        end
        navigation_engine_item text, icon_path, cloud_team.root_path, controller_path.include?("cloud_team")
    end


    # SALES & MARKETING

    # 02.04 House engine
    def navigation_engine_house text: "House", icon_path: "cloud_house/house-logo.svg"
        unless defined? CloudHouse
            return ""
        end
        navigation_engine_item text, icon_path, cloud_house.root_path, controller_path.include?("cloud_house")
    end

    # 02.05 Mailer engine
    def navigation_engine_mailer text: "Mailer", icon_path: "cloud_mailer/mailer-logo.svg"
        unless defined? CloudMailer
            return ""
        end
        navigation_engine_item text, icon_path, cloud_mailer.root_path, controller_path.include?("cloud_mailer")
    end

    # 02.08 Proposal engine
    def navigation_engine_proposal text: "Proposal", icon_path: "cloud_proposal/proposal-logo.svg"
        unless defined? CloudProposal
            return ""
        end
        navigation_engine_item text, icon_path, cloud_proposal.root_path, controller_path.include?("cloud_proposal")
    end


    # PRODUCTIVITY & TEAMWORK

    # 03.01 Driver engine
    def navigation_engine_driver text: "Calendar", icon_path: "cloud_driver/driver-logo.svg"
        unless defined? CloudDriver
            return ""
        end
        return navigation_engine_item text, icon_path, cloud_driver.root_path, controller_path.include?("cloud_driver")
    end

    # 03.02 Work engine
    def navigation_engine_work text: "Projects", icon_path: "cloud_work/work-logo.svg"
        unless defined? CloudWork
            return ""
        end
        return navigation_engine_item text, icon_path, cloud_work.root_path, controller_path.include?("cloud_work")
    end

    # 03.03 Focus engine
    def navigation_engine_focus text: "Tasks", icon_path: "cloud_focus/focus-logo.svg"
        unless defined? CloudFocus
            return ""
        end
        return navigation_engine_item text, icon_path, cloud_focus.root_path, controller_path.include?("cloud_focus")
    end

    # 03.05 Text engine
    def navigation_engine_text text: "Text", icon_path: "cloud_text/text-logo.svg"
        unless defined? CloudText
            return ""
        end
        navigation_engine_item text, icon_path, cloud_text.root_path, controller_path.include?("cloud_text")
    end

    # 03.08 Bell engine
    def navigation_engine_bell text: "Bell", icon_path: "cloud_bell/bell-logo.svg"
        unless defined? CloudBell
            return ""
        end
        navigation_engine_item text, icon_path, cloud_bell.root_path, controller_path.include?("cloud_bell")
    end

    # 03.10 Talk engine
    def navigation_engine_talk text: "Talk", icon_path: "cloud_talk/talk-logo.svg"
        unless defined? CloudTalk
            return ""
        end
        navigation_engine_item text, icon_path, cloud_talk.root_path, controller_path.include?("cloud_talk")
    end

    # 03.11 Storage engine
    def navigation_engine_storage text: "Storage", icon_path: "cloud_storage/storage-logo.svg"
        unless defined? CloudStorage
            return ""
        end
        navigation_engine_item text, icon_path, cloud_storage.root_path, controller_path.include?("cloud_storage")
    end
    
    # FINANCE

    # 04.01 Books engine
    def navigation_engine_books text: "Books", icon_path: "cloud_books/books-logo.svg"
        unless defined? CloudBooks
            return ""
        end
        navigation_engine_item text, icon_path, cloud_books.root_path, controller_path.include?("cloud_books")
    end

    # 04.03 Things engine
    def navigation_engine_things text: "Things", icon_path: "cloud_things/things-logo.svg"
        unless defined? CloudThings
            return ""
        end
        navigation_engine_item text, icon_path, cloud_things.root_path, controller_path.include?("cloud_things")
    end

    # 04.05 Realty engine
    def navigation_engine_realty text: "Realty", icon_path: "cloud_realty/realty-logo.svg"
        unless defined? CloudRealty
            return ""
        end
        navigation_engine_item text, icon_path, cloud_realty.root_path, controller_path.include?("cloud_realty")
    end 


    # ANALYTICS

    # 05.04 Insights engine
    def navigation_engine_insights text: "Insights", icon_path: "cloud_insights/insights-logo.svg"
        unless defined? CloudInsights
            return ""
        end
        navigation_engine_item text, icon_path, cloud_insights.root_path, controller_path.include?("cloud_insights")
    end


    # INTELLIGENCE


    # IT & HELP DESK

    # 07.01 Kb engine
    def navigation_engine_kb text: "Kb", icon_path: "cloud_kb/kb-logo.svg"
        unless defined? CloudKb
            return ""
        end
        navigation_engine_item text, icon_path, cloud_kb.root_path, controller_path.include?("cloud_kb")
    end

    # 07.02 Help engine
    def navigation_engine_help text: "Help", icon_path: "cloud_help/help-logo.svg"
        unless defined? CloudHelp
            return ""
        end
        navigation_engine_item text, icon_path, cloud_help.root_path, controller_path.include?("cloud_help")
    end

    # 07.03 Portal engine
    def navigation_engine_portal text: "Portal", icon_path: "cloud_portal/portal-logo.svg"
        unless defined? CloudPortal
            return ""
        end
        navigation_engine_item text, icon_path, cloud_portal.root_path, controller_path.include?("cloud_portal")
    end

    # 07.05 Shared engine
    def navigation_engine_shared text: "Shared", icon_path: "cloud_shared/shared-logo.svg"
        unless defined? CloudShared
            return ""
        end
        navigation_engine_item text, icon_path, cloud_shared.root_path, controller_path.include?("cloud_shared")
    end


    # SECURITY & PRIVACY

    # 08.03 Audit engine
    def navigation_engine_audit text: "Audit", icon_path: "cloud_audit/audit-logo.svg"
        unless defined? CloudAudit
            return ""
        end
        navigation_engine_item text, icon_path, cloud_audit.root_path, controller_path.include?("cloud_audit")
    end

    
    # INTEGRATIONS

    # 09.01 Babel engine
    def navigation_engine_babel text: "Babel", icon_path: "cloud_babel/babel-logo.svg"
        unless defined? CloudBabel
            return ""
        end
        navigation_engine_item text, icon_path, cloud_babel.root_path, controller_path.include?("cloud_babel")
    end

    # 09.02 Dispatcher engine
    def navigation_engine_dispatcher text: "Dispatcher", icon_path: "cloud_dispatcher/dispatcher-logo.svg"
        unless defined? CloudDispatcher
            return ""
        end
        navigation_engine_item text, icon_path, cloud_dispatcher.root_path, controller_path.include?("cloud_dispatcher")
    end

    # 09.03 Federation engine
    def navigation_engine_federation text: "Federation", icon_path: "cloud_federation/federation-logo.svg"
        unless defined? CloudFederation
            return ""
        end
        navigation_engine_item text, icon_path, cloud_federation.root_path, controller_path.include?("cloud_federation")
    end

    # 09.04 One engine
    def navigation_engine_one text: "One", icon_path: "cloud_one/one-logo.svg"
        unless defined? CloudOne
            return ""
        end
        navigation_engine_item text, icon_path, cloud_one.root_path, controller_path.include?("cloud_one")
    end

    # 09.06 Development engine
    def navigation_engine_development text: "Dev", icon_path: "cloud_development/development-logo.svg"
        unless defined? CloudDevelopment
            return ""
        end
        navigation_engine_item text, icon_path, cloud_development.root_path, controller_path.include?("cloud_development")
    end

end
