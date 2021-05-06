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

    def navigation_container(label, args, &block)
        # does not work
        content_tag("b-menu-item") do
            content_tag("template", :slot => "label", "slot-scope" => "props") do
                content_tag(:i, "", :class => args) +
                        content_tag(:span, label) +
                        %(<b-icon class="is-pulled-right" :icon="props.expanded ? 'caret-down' : 'caret-right'"></b-icon>).html_safe
            end
            (block_given? ? capture(&block) : content) + content_tag(:span, "this is the end")
        end
    end

    def navigation_item(link_path)
        class_name = request.original_fullpath.include?(link_path) ? "is-active" : nil
        class_name = current_page?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
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

    def navigation_engine_category(text, engine_tags)
        if engine_tags.blank?
            return
        end
        content_tag(:div, :class=>"module") do
            content_tag(:p, text) +
            engine_tags.html_safe
        end
    end

    # 00.00 System administration
    def navigation_administration text: "Admin", icon_path: "icons/administration-logo.svg"
        navigation_engine_item text, icon_path, main_app.account_path
    end

    # ADMINISTRATION
    def navigation_administration_category(text: "Administration")
        engines = navigation_engine_team
        navigation_engine_category(text, engines)
    end

    # 01.01 Team engine
    def navigation_engine_team text: "Team", icon_path: "cloud_team/team-logo.svg"
        unless defined? CloudTeam
            return ""
        end
        navigation_engine_item text, icon_path, cloud_team.root_path, controller_path.include?("cloud_team")
    end

    # SALES & MARKETING
    def navigation_sales_marketing_category(text: "Sales & marketing")
        engines = navigation_engine_house + navigation_engine_mailer + navigation_engine_proposal
        navigation_engine_category(text, engines)
    end

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

    def navigation_productivity_teamwork_category(text: "Productivity & teamwork")
        engines = navigation_engine_driver + navigation_engine_work + navigation_engine_focus + navigation_engine_text + navigation_engine_bell + navigation_engine_talk
        navigation_engine_category(text, engines)
    end

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

    # FINANCE

    def navigation_finance_category(text: "Finance")
        engines = navigation_engine_books + navigation_engine_things
        navigation_engine_category(text, engines)
    end

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

    # ANALYTICS
    def navigation_analytics_category(text: "Analytics")
        engines = navigation_engine_insights
        navigation_engine_category(text, engines)
    end

    # 05.04 Insights engine
    def navigation_engine_insights text: "Insights", icon_path: "cloud_insights/insights-logo.svg"
        unless defined? CloudInsights
            return ""
        end
        navigation_engine_item text, icon_path, cloud_insights.root_path, controller_path.include?("cloud_insights")
    end

    # INTELLIGENCE

    # IT & HELP DESK

    def navigation_it_help_desk_category(text: "IT & Help desk")
        engines = navigation_engine_help + navigation_engine_portal + navigation_engine_shared
        navigation_engine_category(text, engines)
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

    def navigation_security_privacy_category(text: "Security & privacy")
        engines = navigation_engine_audit
        navigation_engine_category(text, engines)
    end

    # 08.03 Audit engine
    def navigation_engine_audit text: "Audit", icon_path: "cloud_audit/audit-logo.svg"
        unless defined? CloudAudit
            return ""
        end
        navigation_engine_item text, icon_path, cloud_audit.root_path, controller_path.include?("cloud_audit")
    end

    # INTEGRATIONS

    def navigation_integrations_category(text: "Integrations")
        engines = navigation_engine_babel + navigation_engine_federation + navigation_engine_one + navigation_engine_development
        navigation_engine_category(text, engines)
    end

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
