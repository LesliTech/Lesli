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

require "rails_helper"
require "spec_helper"
require "byebug"

require "yaml"


RSpec.describe "Config/database.yml" do

    before(:all) do
        @database = YAML.load(File.read(Rails.root.join("config", "database.yml")))
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
        expect(@database["development"]["database"]).to eql("<%= Rails.application.credentials.db[:database] %>")
        expect(@database["development"]["username"]).to eql("<%= Rails.application.credentials.db[:username] %>")
        expect(@database["development"]["password"]).to eql("<%= Rails.application.credentials.db[:password] %>")
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
        expect(@database["test"]["database"]).to eql("<%= Rails.application.credentials.db[:database] %>")
        expect(@database["test"]["username"]).to eql("<%= Rails.application.credentials.db[:username] %>")
        expect(@database["test"]["password"]).to eql("<%= Rails.application.credentials.db[:password] %>")
        expect(@database["test"]["port"]).to eql("<%= Rails.application.credentials.db[:port] %>")
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
        expect(@database["production"]["host"]).to eql("<%= Rails.application.credentials.db[:host] %>")
        expect(@database["production"]["adapter"]).to eql("postgresql")
        expect(@database["production"]["encoding"]).to eql("unicode")
        expect(@database["production"]["reconnect"]).to eql(false)
        expect(@database["production"]["database"]).to eql("<%= Rails.application.credentials.db[:database] %>")
        expect(@database["production"]["username"]).to eql("<%= Rails.application.credentials.db[:username] %>")
        expect(@database["production"]["password"]).to eql("<%= Rails.application.credentials.db[:password] %>")
        expect(@database["production"]["port"]).to eql("<%= Rails.application.credentials.db[:port] %>")
    end

    it "expect to have a configuration section for environment: production_dev" do
        expect(@database).to have_key("production_dev") 
        expect(@database["production_dev"]).to have_key("pool") 
        expect(@database["production_dev"]).to have_key("host") 
        expect(@database["production_dev"]).to have_key("adapter") 
        expect(@database["production_dev"]).to have_key("encoding") 
        expect(@database["production_dev"]).to have_key("reconnect") 
        expect(@database["production_dev"]).to have_key("database") 
        expect(@database["production_dev"]).to have_key("username") 
        expect(@database["production_dev"]).to have_key("password") 

        expect(@database["production_dev"]["pool"]).to eql(30)
        expect(@database["production_dev"]["host"]).to eql("127.0.0.1")
        expect(@database["production_dev"]["adapter"]).to eql("postgresql")
        expect(@database["production_dev"]["encoding"]).to eql("unicode")
        expect(@database["production_dev"]["reconnect"]).to eql(false)
        expect(@database["production_dev"]["database"]).to eql("<%= Rails.application.credentials.db[:database] %>")
        expect(@database["production_dev"]["username"]).to eql("<%= Rails.application.credentials.db[:username] %>")
        expect(@database["production_dev"]["password"]).to eql("<%= Rails.application.credentials.db[:password] %>")
    end

end
