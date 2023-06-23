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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require "yaml"
require "support/config/rails_helper"

RSpec.describe "Config/database.yml" do

    before(:all) do
        @database = YAML.unsafe_load(File.read(Rails.root.join("config", "database.yml")))
    end

    it "expect to have a common configuration section" do
        expect(@database).to have_key("common") 
        expect(@database["common"]).to have_key("pool") 
        expect(@database["common"]).to have_key("host") 
        expect(@database["common"]).to have_key("adapter") 
        expect(@database["common"]).to have_key("encoding") 
        expect(@database["common"]).to have_key("reconnect") 

        expect(@database["common"]["pool"]).to eql(30)
        expect(@database["common"]["host"]).to eql("127.0.0.1")
        expect(@database["common"]["adapter"]).to eql("postgresql")
        expect(@database["common"]["encoding"]).to eql("unicode")
        expect(@database["common"]["reconnect"]).to eql(false)
    end

    it "expect to have a configuration section for environment: development" do
        expect(@database).to have_key("development") 
        expect(@database["development"]).to have_key("pool") 
        expect(@database["development"]).to have_key("host") 
        expect(@database["development"]).to have_key("adapter") 
        expect(@database["development"]).to have_key("encoding") 
        expect(@database["development"]).to have_key("reconnect") 
        expect(@database["development"]).to have_key("database") 
        expect(@database["development"]).to have_key("username") 
        expect(@database["development"]).to have_key("password") 

        expect(@database["development"]["pool"]).to eql(30)
        expect(@database["development"]["host"]).to eql("127.0.0.1")
        expect(@database["development"]["adapter"]).to eql("postgresql")
        expect(@database["development"]["encoding"]).to eql("unicode")
        expect(@database["development"]["reconnect"]).to eql(false)
        expect(@database["development"]["database"]).to eql("<%= Rails.application.credentials.dig(:db, :database) %>")
        expect(@database["development"]["username"]).to eql("<%= Rails.application.credentials.dig(:db, :username) %>")
        expect(@database["development"]["password"]).to eql("<%= Rails.application.credentials.dig(:db, :password) %>")
    end

    it "expect to have a configuration section for environment: test" do
        expect(@database).to have_key("test") 
        expect(@database["test"]).to have_key("pool") 
        expect(@database["test"]).to have_key("host") 
        expect(@database["test"]).to have_key("adapter") 
        expect(@database["test"]).to have_key("encoding") 
        expect(@database["test"]).to have_key("reconnect") 
        expect(@database["test"]).to have_key("database") 
        expect(@database["test"]).to have_key("username") 
        expect(@database["test"]).to have_key("password") 
        expect(@database["test"]).to have_key("port") 

        expect(@database["test"]["pool"]).to eql(30)
        expect(@database["test"]["host"]).to eql("127.0.0.1")
        expect(@database["test"]["adapter"]).to eql("postgresql")
        expect(@database["test"]["encoding"]).to eql("unicode")
        expect(@database["test"]["reconnect"]).to eql(false)
        expect(@database["test"]["database"]).to eql("<%= Rails.application.credentials.dig(:db, :database) %>")
        expect(@database["test"]["username"]).to eql("<%= Rails.application.credentials.dig(:db, :username) %>")
        expect(@database["test"]["password"]).to eql("<%= Rails.application.credentials.dig(:db, :password) %>")
    end

    it "expect to have a configuration section for environment: production" do
        expect(@database).to have_key("production") 
        expect(@database["production"]).to have_key("pool") 
        expect(@database["production"]).to have_key("host") 
        expect(@database["production"]).to have_key("adapter") 
        expect(@database["production"]).to have_key("encoding") 
        expect(@database["production"]).to have_key("reconnect") 
        expect(@database["production"]).to have_key("database") 
        expect(@database["production"]).to have_key("username") 
        expect(@database["production"]).to have_key("password") 
        expect(@database["production"]).to have_key("port") 

        expect(@database["production"]["pool"]).to eql(30)
        expect(@database["production"]["adapter"]).to eql("postgresql")
        expect(@database["production"]["encoding"]).to eql("unicode")
        expect(@database["production"]["reconnect"]).to eql(false)
        expect(@database["production"]["database"]).to eql("<%= Rails.application.credentials.dig(:db, :database) %>")
        expect(@database["production"]["username"]).to eql("<%= Rails.application.credentials.dig(:db, :username) %>")
        expect(@database["production"]["password"]).to eql("<%= Rails.application.credentials.dig(:db, :password) %>")
    end

end
