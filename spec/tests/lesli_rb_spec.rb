=begin
Copyright (c) 2023, all rights reserved.

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
require "support/config/rails_helper"


RSpec.describe "Lesli::engines" do

    before(:all) do
        @lesli_engines = Lesli::engines()
    end

    it "expect to return with an array of engines and gems" do

        expect(@lesli_engines).to be_an(Array)

        unless @lesli_engines.empty?

            @lesli_engines.each do |engine|

                expect(engine).to have_key(:type)
                expect(engine[:type]).to be_a(String)

                expect(engine).to have_key(:code)
                expect(engine[:code]).to be_a(String)

                expect(engine).to have_key(:name)
                expect(engine[:name]).to be_a(String)

                expect(engine).to have_key(:version)

                if engine[:type] == "engine" || engine[:type] == "builder"
                    expect(engine).to have_key(:github)
                    expect(engine[:version]).to be_a(String)
                    expect(engine[:version]).to eql("latest")
                end
            end
        end
    end
end

RSpec.describe "Lesli::instance" do

    before(:all) do
        @lesli_instance = Lesli::instance()
    end

    it "expect to return with a hash of lesli instance" do
        expect(@lesli_instance).to be_a(Hash)

        expect(@lesli_instance).to have_key(:name)
        expect(@lesli_instance[:name]).to be_a(String)

        expect(@lesli_instance).to have_key(:code)
        expect(@lesli_instance[:code]).to be_a(String)

    end
end


RSpec.describe "Lesli::settings" do

    before(:all) do
        @lesli_settings = Lesli::settings()
    end

    it "expect to return with a hash of lesli settings" do
        expect(@lesli_settings).to be_a(Hash)
    end

    it "expect to return with lesli info settings" do

        expect(@lesli_settings).to have_key("info")
        expect(@lesli_settings["info"]).to be_a(Hash)

        expect(@lesli_settings["info"]).to have_key("name")
        expect(@lesli_settings["info"]["name"]).to be_a(String)

        expect(@lesli_settings["info"]).to have_key("code")
        expect(@lesli_settings["info"]["code"]).to be_a(String)

        expect(@lesli_settings["info"]).to have_key("github")
        expect(@lesli_settings["info"]["github"]).to be_a(Hash)

        expect(@lesli_settings["info"]["github"]).to have_key("url")
        expect(@lesli_settings["info"]["github"]["url"]).to be_a(String)

        expect(@lesli_settings["info"]["github"]).to have_key("ssh")
        expect(@lesli_settings["info"]["github"]["ssh"]).to be_a(String)
    end

    it "expect to return with lesli account" do
        expect(@lesli_settings).to have_key("account")
        expect(@lesli_settings["account"]).to be_a(Hash)

        expect(@lesli_settings["account"]).to have_key("email")
        expect(@lesli_settings["account"]["email"]).to be_a(String)

        expect(@lesli_settings["account"]).to have_key("name")
        expect(@lesli_settings["account"]["name"]).to be_a(String)

        expect(@lesli_settings["account"]).to have_key("email")
        expect(@lesli_settings["account"]["email"]).to be_a(String)

        expect(@lesli_settings["account"]).to have_key("tag_line")
        expect(@lesli_settings["account"]["tag_line"]).to be_a(String)
    end

    it "expect to return with lesli configuration" do

        expect(@lesli_settings).to have_key("configuration")
        expect(@lesli_settings["configuration"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]).to have_key("locales_available")
        expect(@lesli_settings["configuration"]["locales_available"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["locales_available"]).to have_key("en")
        expect(@lesli_settings["configuration"]["locales_available"]["en"]).to be_a(String)

        expect(@lesli_settings["configuration"]).to have_key("locales")
        expect(@lesli_settings["configuration"]["locales"]).to be_an(Array)
        expect(@lesli_settings["configuration"]["locales"]).to include("en")

        expect(@lesli_settings["configuration"]).to have_key("datetime")
        expect(@lesli_settings["configuration"]["datetime"]).to be_a(Hash)
    end

    it "expect to return with lesli configuration settings locales" do
        expect(@lesli_settings["configuration"]["locales"]).to include("en")
        expect(@lesli_settings["configuration"]["locales"]).to be_an(Array)

        expect(@lesli_settings["configuration"]["locales_available"]).to be_an(Hash)
        expect(@lesli_settings["configuration"]["locales_available"]).to have_key("en")
        expect(@lesli_settings["configuration"]["locales_available"]["en"]).to eql("English")
    end

    it "expect to return with lesli configuration settings datetime" do
        expect(@lesli_settings["configuration"]).to have_key("datetime")
        expect(@lesli_settings["configuration"]["datetime"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("time_zone")
        expect(@lesli_settings["configuration"]["datetime"]["time_zone"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["time_zone"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :time_zone))

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("start_week_on")
        expect(@lesli_settings["configuration"]["datetime"]["start_week_on"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["start_week_on"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :start_week_on))

        expect(@lesli_settings["configuration"]["datetime"]).to have_key("formats")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to be_a(Hash)

        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to have_key("date")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :formats, :date))

        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to have_key("time")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["time"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["time"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :formats, :time))

        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to have_key("date_time")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_time"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_time"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :formats, :date_time))

        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to have_key("date_words")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_words"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_words"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :formats, :date_words))

        expect(@lesli_settings["configuration"]["datetime"]["formats"]).to have_key("date_time_words")
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_time_words"]).to be_a(String)
        expect(@lesli_settings["configuration"]["datetime"]["formats"]["date_time_words"]).to eql(Rails.application.config.lesli.dig(:configuration, :datetime, :formats, :date_time_words))
    end

    it "expect to return with lesli security" do

        expect(@lesli_settings).to have_key("security")
        expect(@lesli_settings).to be_a(Hash)

        expect(@lesli_settings["security"]).to have_key("enable_debug")
        expect(@lesli_settings["security"]["enable_debug"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("enable_becoming")
        expect(@lesli_settings["security"]["enable_becoming"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("enable_analytics")
        expect(@lesli_settings["security"]["enable_analytics"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("enable_login_otp")
        expect(@lesli_settings["security"]["enable_login_otp"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("enable_login_link")
        expect(@lesli_settings["security"]["enable_login_link"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("allow_multiaccount")
        expect(@lesli_settings["security"]["allow_multiaccount"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("allow_registration")
        expect(@lesli_settings["security"]["allow_registration"]).to be_in([true, false])

        expect(@lesli_settings["security"]).to have_key("password")
        expect(@lesli_settings["security"]["password"]).to be_a(String)

    end

    it "expect to return with lesli env settings" do

        expect(@lesli_settings).to have_key("env")
        expect(@lesli_settings["env"]).to be_a(Hash)

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

    it "expect to return with a engines key" do

        expect(@lesli_settings).to have_key("engines")
        expect(@lesli_settings["engines"]).to be_an(Array)

    end

    it "expect to return with a instance key" do

        expect(@lesli_settings).to have_key("instance")
        expect(@lesli_settings["instance"]).to be_a(Hash)

        expect(@lesli_settings["instance"]).to have_key(:name)
        expect(@lesli_settings["instance"][:name]).to be_a(String)

        expect(@lesli_settings["instance"]).to have_key(:code)
        expect(@lesli_settings["instance"][:code]).to be_a(String)

    end

end