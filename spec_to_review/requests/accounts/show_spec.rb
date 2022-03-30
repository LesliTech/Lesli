=begin
Copyright (c) 2021, all rights reserved.

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

require 'rails_helper'
require 'spec_helper'
require 'byebug'


[
    { 
        :company_name => Faker::Company.name,
        :status => "active",
        :company_name_legal => Faker::Company.name,
        :company_tag_line => Faker::Company.name,
        :country => Faker::Number.within(range: 1..195),
        :address => Faker::Address.full_address,
        :region => "latin_america",
        :website => Faker::Internet.url,
        :phone_number_1 => Faker::PhoneNumber.phone_number,
        :phone_number_2 => Faker::PhoneNumber.phone_number,
        :phone_number_3 => Faker::PhoneNumber.phone_number,
        :phone_number_4 => Faker::PhoneNumber.phone_number,
        :public_email => Faker::Internet.email,
        :github => Faker::Internet.url(host: 'www.github.com'),
        :twitter => Faker::Internet.url(host: 'www.twitter.com'),
        :youtube => Faker::Internet.url(host: 'www.youtube.com'),
        :linkedin => Faker::Internet.url(host: 'www.linkedin.com'),
        :facebook => Faker::Internet.url(host: 'www.facebook.com'),
    },
    { 
        :company_name => Faker::Company.name,
        :status => "active",
        :company_name_legal => nil,
        :company_tag_line => nil,
        :country => nil,
        :address => nil,
        :region => nil,
        :website => nil,
        :phone_number_1 => nil,
        :phone_number_2 => nil,
        :phone_number_3 => nil,
        :phone_number_4 => nil,
        :public_email => nil,
        :github => nil,
        :twitter => nil,
        :youtube => nil,
        :linkedin => nil,
        :facebook => nil,
    },
    {
        :company_name => Faker::Company.name,
        :status => "active",
    },
].each do |account|

    RSpec.describe "GET:/administration/account.json", type: :request do

        include_context 'user authentication'

        before(:all) do
            # company_name and status must be present
            @user.account.update(
                company_name: account[:company_name],
                status: account[:status],
                company_name_legal: account[:company_name_legal],
                company_tag_line: account[:company_tag_line],
                country: account[:country],
                address: account[:address],
                region: account[:region],
                website: account[:website],
                phone_number_1: account[:phone_number_1],
                phone_number_2: account[:phone_number_2],
                phone_number_3: account[:phone_number_3],
                phone_number_4: account[:phone_number_4],
                public_email: account[:public_email],
                github: account[:github],
                twitter: account[:twitter],
                youtube: account[:youtube],
                linkedin: account[:linkedin],
                facebook: account[:facebook],
            )            

            get("/administration/account.json")
        end

        include_examples 'successful standard json response'

        it "is expected to return with a hash administration account with all keys and values" do

            expect(@response_body_data).to be_a(Hash)
            
            expect(@response_body_data).to have_key("id")
            expect(@response_body_data["id"]).to be_a(Numeric)
            
            expect(@response_body_data).to have_key("status")
            expect(@response_body_data["status"]).to be_a(String)

            expect(@response_body_data).to have_key("company_name")
            expect(@response_body_data["company_name"]).to be_a(String)

            expect(@response_body_data).to have_key("company_name_legal")

            if @response_body_data["company_name_legal"]
                expect(@response_body_data["company_name_legal"]).to be_a(String)
            else 
                expect(@response_body_data["company_name_legal"]).to be_nil
            end
            
            expect(@response_body_data).to have_key("company_tag_line")

            if @response_body_data["company_tag_line"]
                expect(@response_body_data["company_tag_line"]).to be_a(String)
            else 
                expect(@response_body_data["company_tag_line"]).to be_nil
            end

            expect(@response_body_data).to have_key("country")

            if @response_body_data["country"]
                expect(@response_body_data["country"]).to be_a(Numeric)
            else
                expect(@response_body_data["country"]).to be_nil
            end        

            expect(@response_body_data).to have_key("address")
            
            if @response_body_data["address"]
                expect(@response_body_data["address"]).to be_a(String)
            else
                expect(@response_body_data["address"]).to be_nil
            end
            
            expect(@response_body_data).to have_key("region")
            
            if @response_body_data["region"]
                expect(@response_body_data["region"]).to be_a(String)
            else 
                expect(@response_body_data["region"]).to be_nil
            end

            expect(@response_body_data).to have_key("website")
            
            if @response_body_data["website"]
                expect(@response_body_data["website"]).to be_a(String)
            else 
                expect(@response_body_data["website"]).to be_nil
            end

            expect(@response_body_data).to have_key("phone_number_1")
            
            if @response_body_data["phone_number_1"]
                expect(@response_body_data["phone_number_1"]).to be_a(String)
            else 
                expect(@response_body_data["phone_number_1"]).to be_nil
            end

            expect(@response_body_data).to have_key("phone_number_2")
            
            if @response_body_data["phone_number_2"]
                expect(@response_body_data["phone_number_2"]).to be_a(String)
            else 
                expect(@response_body_data["phone_number_2"]).to be_nil
            end

            expect(@response_body_data).to have_key("phone_number_3")
            
            if @response_body_data["phone_number_3"]
                expect(@response_body_data["phone_number_3"]).to be_a(String)
            else 
                expect(@response_body_data["phone_number_3"]).to be_nil
            end

            expect(@response_body_data).to have_key("phone_number_4")
            
            if @response_body_data["phone_number_4"]
                expect(@response_body_data["phone_number_4"]).to be_a(String)
            else
                expect(@response_body_data["phone_number_4"]).to be_nil
            end

            expect(@response_body_data).to have_key("public_email")
            
            if @response_body_data["public_email"]
                expect(@response_body_data["public_email"]).to be_a(String)
            else
                expect(@response_body_data["public_email"]).to be_nil
            end

            expect(@response_body_data).to have_key("github")
            
            if @response_body_data["github"]
                expect(@response_body_data["github"]).to be_a(String)
            else
                expect(@response_body_data["github"]).to be_nil
            end

            expect(@response_body_data).to have_key("twitter")
            
            if @response_body_data["twitter"]
                expect(@response_body_data["twitter"]).to be_a(String)
            else
                expect(@response_body_data["twitter"]).to be_nil
            end

            expect(@response_body_data).to have_key("youtube")
            
            if @response_body_data["youtube"]
                expect(@response_body_data["youtube"]).to be_a(String)
            else
                expect(@response_body_data["youtube"]).to be_nil
            end

            expect(@response_body_data).to have_key("linkedin")
            
            if @response_body_data["linkedin"]
                expect(@response_body_data["linkedin"]).to be_a(String)
            else
                expect(@response_body_data["linkedin"]).to be_nil
            end

            expect(@response_body_data).to have_key("facebook")
            
            if @response_body_data["facebook"]
                expect(@response_body_data["facebook"]).to be_a(String)
            else
                expect(@response_body_data["facebook"]).to be_nil
            end

            expect(@response_body_data).to have_key("created_at")
            expect(@response_body_data["created_at"]).to be_a(String)

            expect(@response_body_data).to have_key("updated_at")
            expect(@response_body_data["updated_at"]).to be_a(String)

            expect(@response_body_data).to have_key("users_id")
            expect(@response_body_data["users_id"]).to be_a(Numeric)

        end

    end

end
