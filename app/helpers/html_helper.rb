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

    # 00.00 System administration
    def navigation_administration text: "Admin", icon_path: "icons/administration-logo.svg"
        navigation_engine_item text, icon_path, main_app.account_path
    end

    # ADMINISTRATION

    # 01.01 Team engine
    def navigation_engine_team text: "Team", icon_path: "cloud_team/team-logo.svg"
        if defined? CloudTeam
            navigation_engine_item text, icon_path, cloud_team.root_path, controller_path.include?("cloud_team")
        end
    end

    # SALES & MARKETING

    # 02.04 House engine
    def navigation_engine_house text: "House", icon_path: "cloud_house/house-logo.svg"
        if defined? CloudHouse
            navigation_engine_item text, icon_path, cloud_house.root_path, controller_path.include?("cloud_house")
        end
    end

    # 02.05 Mailer engine
    def navigation_engine_mailer text: "Mailer", icon_path: "cloud_mailer/mailer-logo.svg"
        if defined? CloudMailer
            navigation_engine_item text, icon_path, cloud_mailer.root_path, controller_path.include?("cloud_mailer")
        end
    end

    # 02.08 Proposal engine
    def navigation_engine_proposal text: "Proposal", icon_path: "cloud_proposal/proposal-logo.svg"
        if defined? CloudProposal
            navigation_engine_item text, icon_path, cloud_proposal.root_path, controller_path.include?("cloud_proposal")
        end
    end

    # PRODUCTIVITY & TEAMWORK

    # 03.01 Driver engine
    def navigation_engine_driver text: "Calendar", icon_path: "cloud_driver/driver-logo.svg"
        if defined? CloudDriver
            navigation_engine_item text, icon_path, cloud_driver.root_path, controller_path.include?("cloud_driver")
        end
    end

    # 03.03 Focus engine
    def navigation_engine_focus text: "Tasks", icon_path: "cloud_focus/focus-logo.svg"
        if defined? CloudFocus
            navigation_engine_item text, icon_path, cloud_focus.root_path, controller_path.include?("cloud_focus")
        end
    end

    # 03.05 Text engine
    def navigation_engine_text text: "Text", icon_path: "cloud_text/text-logo.svg"
        if defined? CloudText
            navigation_engine_item text, icon_path, cloud_text.root_path, controller_path.include?("cloud_text")
        end
    end

    # 03.08 Bell engine
    def navigation_engine_bell text: "Bell", icon_path: "cloud_bell/bell-logo.svg"
        if defined? CloudBell
            navigation_engine_item text, icon_path, cloud_bell.root_path, controller_path.include?("cloud_bell")
        end
    end

    # 03.10 Talk engine
    def navigation_engine_talk text: "Talk", icon_path: "cloud_talk/talk-logo.svg"
        if defined? CloudTalk
            navigation_engine_item text, icon_path, cloud_talk.root_path, controller_path.include?("cloud_talk")
        end
    end

    # FINANCE

    # 04.03 Things engine
    def navigation_engine_things text: "Things", icon_path: "cloud_things/things-logo.svg"
        if defined? CloudThings
            navigation_engine_item text, icon_path, cloud_things.root_path, controller_path.include?("cloud_things")
        end
    end

    # ANALYTICS

    # INTELLIGENCE

    # IT & HELP DESK

    # 07.02 Help engine
    def navigation_engine_help text: "Help", icon_path: "cloud_help/help-logo.svg"
        if defined? CloudHelp
            navigation_engine_item text, icon_path, cloud_help.root_path, controller_path.include?("cloud_help")
        end
    end

    # 07.03 Portal engine
    def navigation_engine_portal text: "Portal", icon_path: "cloud_portal/portal-logo.svg"
        if defined? CloudPortal
            navigation_engine_item text, icon_path, cloud_portal.root_path, controller_path.include?("cloud_portal")
        end
    end

    # SECURITY & PRIVACY

    # 08.03 Audit engine
    def navigation_engine_audit text: "Audit", icon_path: "cloud_audit/audit-logo.svg"
        if defined? CloudAudit
            navigation_engine_item text, icon_path, cloud_audit.root_path, controller_path.include?("cloud_audit")
        end
    end

    # INTEGRATIONS

    # 09.01 Babel engine
    def navigation_engine_babel text: "Babel", icon_path: "cloud_babel/babel-logo.svg"
        if defined? CloudBabel
            navigation_engine_item text, icon_path, cloud_babel.root_path, controller_path.include?("cloud_babel")
        end
    end

    # 09.02 Dispatcher engine
    def navigation_engine_dispatcher text: "Dispatcher", icon_path: "cloud_dispatcher/dispatcher-logo.svg"
        if defined? CloudDispatcher
            navigation_engine_item text, icon_path, cloud_dispatcher.root_path, controller_path.include?("cloud_dispatcher")
        end
    end

    # 09.03 Federation engine
    def navigation_engine_federation text: "Federation", icon_path: "cloud_federation/federation-logo.svg"
        if defined? CloudFederation
            navigation_engine_item text, icon_path, cloud_federation.root_path, controller_path.include?("cloud_federation")
        end
    end

    # 09.04 One engine
    def navigation_engine_one text: "One", icon_path: "cloud_one/one-logo.svg"
        if defined? CloudOne
            navigation_engine_item text, icon_path, cloud_one.root_path, controller_path.include?("cloud_one")
        end
    end

    # 09.06 Development engine
    def navigation_engine_development text: "Dev", icon_path: "cloud_development/development-logo.svg"
        if defined? CloudDevelopment
            navigation_engine_item text, icon_path, cloud_development.root_path, controller_path.include?("cloud_development")
        end
    end

end
