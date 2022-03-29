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

require "./lesli"
require "rails_helper"


RSpec.describe "lesli_settings.yml" do

    before(:all) do
        @lesli_settings = Lesli::settings()
    end

    it "expect to have a section for info settings" do
        expect(@lesli_settings).to have_key("info")
        expect(@lesli_settings["info"]).to have_key("name")
        expect(@lesli_settings["info"]).to have_key("code")

        expect(@lesli_settings["info"]).to have_key("github")
        expect(@lesli_settings["info"]["github"]).to have_key("url")
        expect(@lesli_settings["info"]["github"]).to have_key("ssh")
        expect(@lesli_settings["info"]["github"]).to have_key("ssh_backup")
    end

    it "expect to have a section for modules settings" do
        expect(@lesli_settings).to have_key("modules")

        if @lesli_settings["modules"].kind_of?(Array)
            expect(@lesli_settings["modules"]).to be_an(Array)
        else
            expect(@lesli_settings["modules"]).to be_an(Hash)
            expect(@lesli_settings["modules"].keys.count).to be >= (0)
        end

    end

    it "expect to have a section for account settings" do
        expect(@lesli_settings).to have_key("account")
        expect(@lesli_settings["account"]).to have_key("user")
        expect(@lesli_settings["account"]["user"]).to have_key("name")
        expect(@lesli_settings["account"]["user"]).to have_key("email")

        expect(@lesli_settings["account"]).to have_key("company")
        expect(@lesli_settings["account"]["company"]).to have_key("name")
        expect(@lesli_settings["account"]["company"]).to have_key("email")
        expect(@lesli_settings["account"]["company"]).to have_key("tag_line")

        expect(@lesli_settings["account"]).to have_key("website")
        expect(@lesli_settings["account"]["website"]).to have_key("title_prefix")
    end

    it "expect to have a section for configuration settings" do
        expect(@lesli_settings).to have_key("configuration")
        expect(@lesli_settings["configuration"]).to have_key("theme")
        expect(@lesli_settings["configuration"]).to have_key("locales")
    end

    it "expect to have a section for configuration locales settings" do
        expect(@lesli_settings["configuration"]["locales"]).to be_an(Array)
        expect(@lesli_settings["configuration"]["locales"].size).to be > (1)
        expect(@lesli_settings["configuration"]["locales_available"]).to be_a(Hash)
    end

    it "expect to have a section for configuration datetime settings" do
        expect(@lesli_settings["configuration"]).to have_key("datetime")
        expect(@lesli_settings["configuration"]["datetime"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("date_format")
        expect(@lesli_settings["configuration"]["datetime"]["date_format"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("date_format_full")
        expect(@lesli_settings["configuration"]["datetime"]["date_format_full"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("date_format_time")
        expect(@lesli_settings["configuration"]["datetime"]["date_format_time"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("start_week_on")
        expect(@lesli_settings["configuration"]["datetime"]["start_week_on"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("time_format")
        expect(@lesli_settings["configuration"]["datetime"]["time_format"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("time_zone")
        expect(@lesli_settings["configuration"]["datetime"]["time_zone"]).to be_a(String)
    end

    it "expect to have a section for configuration datetime2 settings" do
        expect(@lesli_settings["configuration"]).to have_key("datetime2")
        expect(@lesli_settings["configuration"]["datetime2"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["datetime2"]).to have_key("time_zone")
        expect(@lesli_settings["configuration"]["datetime"]["time_zone"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]).to have_key("start_week_on")
        expect(@lesli_settings["configuration"]["datetime"]["start_week_on"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]).to have_key("formats")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to have_key("date")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]["date"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to have_key("time")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]["time"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to have_key("date_time")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]["date_time"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to have_key("date_words")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]["date_words"]).to be_a(String)

        expect(@lesli_settings["configuration"]["datetime2"]["formats"]).to have_key("date_time_words")
        expect(@lesli_settings["configuration"]["datetime2"]["formats"]["date_time_words"]).to be_a(String)
    end

    it "expect to have a section for notifications settings" do
        expect(@lesli_settings["configuration"]).to have_key("notifications")
        expect(@lesli_settings["configuration"]["notifications"]).to have_key("sms")
        expect(@lesli_settings["configuration"]["notifications"]["sms"]).to be_in([true, false])
    end

    it "expect to have a section for security settings" do
        expect(@lesli_settings).to have_key("security")
        expect(@lesli_settings["security"]).to have_key("password")
        expect(@lesli_settings["security"]["password"]).to have_key("development")
        expect(@lesli_settings["security"]["password"]).to have_key("minimum_length")
        expect(@lesli_settings["security"]["password"]).to have_key("expiration_time_days")

        expect(@lesli_settings["security"]["password"]["development"]).to be_a(String)
        expect(@lesli_settings["security"]["password"]["minimum_length"]).to be_a(Numeric)
        expect(@lesli_settings["security"]["password"]["expiration_time_days"]).to be_a(Numeric)

        expect(@lesli_settings["security"]).to have_key("allow_multiaccount")
        expect(@lesli_settings["security"]).to have_key("allow_registration")
        expect(@lesli_settings["security"]).to have_key("allow_invitation")
        expect(@lesli_settings["security"]).to have_key("enable_login_link")
        expect(@lesli_settings["security"]).to have_key("enable_login_otp")
        expect(@lesli_settings["security"]).to have_key("enable_becoming")
        expect(@lesli_settings["security"]).to have_key("enable_debug")
        expect(@lesli_settings["security"]).to have_key("enable_analytics")
        expect(@lesli_settings["security"]).to have_key("enable_commands")
        expect(@lesli_settings["security"]).to have_key("log_activity")

        expect(@lesli_settings["security"]["allow_multiaccount"]).to be_in([true, false])
        expect(@lesli_settings["security"]["allow_registration"]).to be_in([true, false])
        expect(@lesli_settings["security"]["allow_invitation"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_login_link"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_login_otp"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_becoming"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_debug"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_analytics"]).to be_in([true, false])
        expect(@lesli_settings["security"]["enable_commands"]).to be_in([true, false])
        expect(@lesli_settings["security"]["log_activity"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("roles")
        if @lesli_settings["security"]["roles"]
            expect(@lesli_settings["security"]["roles"]).to be_an(Array)
            expect(@lesli_settings["security"]["roles"].size).to be >= (0)
        end

    end

    it "expect to have a section for environment settings" do
        expect(@lesli_settings).to have_key("env")
        expect(@lesli_settings["env"]).to have_key("default_locale")
        expect(@lesli_settings["env"]["default_locale"]).to be_a(String)

        expect(@lesli_settings["env"]).to have_key("default_url")
        expect(@lesli_settings["env"]["default_url"]).to be_a(String)

        expect(@lesli_settings["env"]).to have_key("action_mailer")
        expect(@lesli_settings["env"]["action_mailer"]).to be_a(Hash)

        expect(@lesli_settings["env"]["action_mailer"]).to have_key("delivery_method")
        expect(@lesli_settings["env"]["action_mailer"]["delivery_method"]).to be_a(String)

        expect(@lesli_settings["env"]["action_mailer"]).to have_key("asset_host")
        expect(@lesli_settings["env"]["action_mailer"]["asset_host"]).to be_a(String)

        expect(@lesli_settings["env"]["action_mailer"]).to have_key("default_options_from")
        expect(@lesli_settings["env"]["action_mailer"]["default_options_from"]).to be_a(String)

        expect(@lesli_settings["env"]["action_mailer"]).to have_key("default_url_options_host")
        expect(@lesli_settings["env"]["action_mailer"]["default_url_options_host"]).to be_a(String)
    end

end
