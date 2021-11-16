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

require "rails_helper"
require "spec_helper"
require "byebug"

new_exchange_rates = [
    {
        :valid_from => Time.now.strftime("%F %H:%M:%S"),
        :valid_to => Time.now.strftime("%F %H:%M:%S"),
        :exchange_rate => Faker::Number.decimal(l_digits: 1, r_digits: 3)
    },
    {
        :valid_from => Time.now.strftime("%F %H:%M:%S"),
        :valid_to => Time.now.strftime("%F %H:%M:%S"),
        :exchange_rate => Faker::Number.decimal(l_digits: 1, r_digits: 4)
    },
    {
        :valid_from => Time.now.strftime("%F %H:%M:%S"),
        :valid_to => Time.now.strftime("%F %H:%M:%S"),
        :exchange_rate => Faker::Number.decimal(l_digits: 3, r_digits: 3)
    }
]

RSpec.describe "GET:/administration/account/currencies/:currency_id/exchange_rates", type: :request do 

    include_context "user authentication"

    before(:all) do 

        # working with a new and clean currency record
        @new_currency = @user.account.currencies.create!({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code,
            user_main_id: @user.id,
            users_id: @user.id
        })

        
        new_exchange_rates.each do |exchange_rate|
            @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!({
                valid_from: exchange_rate[:valid_from],
                valid_to: exchange_rate[:valid_to],
                exchange_rate: exchange_rate[:exchange_rate]
            })
        end
        
        get "/administration/account/currencies/#{@new_currency.id}/exchange_rates.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with all exchange rates by the currency_id given" do 
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data.keys).to contain_exactly("pagination", "records")

        expect(@response_body_data["pagination"]).to be_a(Hash)
        expect(@response_body_data["pagination"].keys).to contain_exactly("total_pages", "current_page", "count_total", "count_results")
        
        expect(@response_body_data["pagination"]["total_pages"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["total_pages"]).to eql(1)

        expect(@response_body_data["pagination"]["current_page"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["current_page"]).to eql(1)

        expect(@response_body_data["pagination"]["count_total"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["count_total"]).to eql(3)

        expect(@response_body_data["pagination"]["count_results"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["count_results"]).to eql(3)

        expect(@response_body_data["records"]).to be_an(Array)
        expect(@response_body_data["records"].length).to eql(new_exchange_rates.length)

        expect(@response_body_data["records"].last).to have_key("id")
        expect(@response_body_data["records"].last["id"]).to be_a(Numeric)

        expect(@response_body_data["records"].last).to have_key("exchange_rate")
        expect(@response_body_data["records"].last["exchange_rate"]).to be_a(String)
        expect(@response_body_data["records"].last["exchange_rate"].to_f).to eql(new_exchange_rates.last[:exchange_rate])

        expect(@response_body_data["records"].last).to have_key("valid_from")
        expect(@response_body_data["records"].last["valid_from"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from"]).to_i).to be > 0
        expect(DateTime.parse(@response_body_data["records"].last["valid_from"]).to_i).to be < (Time.now.to_i)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from"])).to eql(DateTime.parse((new_exchange_rates.last[:valid_from])))
        
        expect(@response_body_data["records"].last).to have_key("valid_to")
        expect(@response_body_data["records"].last["valid_to"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to"]).to_i).to be > 0
        expect(DateTime.parse(@response_body_data["records"].last["valid_to"]).to_i).to be < (Time.now.to_i)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to"])).to eql(DateTime.parse((new_exchange_rates.last[:valid_to])))

        expect(@response_body_data["records"].last).to have_key("account_currencies_id")
        expect(@response_body_data["records"].last["account_currencies_id"]).to be_a(Numeric)
        expect(@response_body_data["records"].last["account_currencies_id"]).to eql(@new_currency.id)

        expect(@response_body_data["records"].last).to have_key("valid_from_string")
        expect(@response_body_data["records"].last["valid_from_string"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from_string"]).to_i).to be > 0
        expect(DateTime.parse(@response_body_data["records"].last["valid_from_string"]).to_i).to be < (Time.now.to_i)

        expect(@response_body_data["records"].last).to have_key("valid_to_string")
        expect(@response_body_data["records"].last["valid_to_string"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to_string"]).to_i).to be > 0
        expect(DateTime.parse(@response_body_data["records"].last["valid_to_string"]).to_i).to be < (Time.now.to_i)

        expect(@response_body_data["records"].last).to have_key("valid_from_text")
        expect(@response_body_data["records"].last["valid_from_text"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from_text"]).year).to eql(DateTime.parse(@response_body_data["records"].last["valid_from"]).year)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from_text"]).month).to eql(DateTime.parse(@response_body_data["records"].last["valid_from"]).month)
        expect(DateTime.parse(@response_body_data["records"].last["valid_from_text"]).day).to eql(DateTime.parse(@response_body_data["records"].last["valid_from"]).day)

        expect(@response_body_data["records"].last).to have_key("valid_to_text")
        expect(@response_body_data["records"].last["valid_to_text"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to_text"]).year).to eql(DateTime.parse(@response_body_data["records"].last["valid_to"]).year)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to_text"]).month).to eql(DateTime.parse(@response_body_data["records"].last["valid_to"]).month)
        expect(DateTime.parse(@response_body_data["records"].last["valid_to_text"]).day).to eql(DateTime.parse(@response_body_data["records"].last["valid_to"]).day)
    
        expect(@response_body_data["records"].last).to have_key("created_at_date")
        expect(@response_body_data["records"].last["created_at_date"]).to be_a(String)
        expect(@response_body_data["records"].last["created_at_date"].to_i).to be > 0
        expect(@response_body_data["records"].last["created_at_date"].to_i).to be < (Time.now.to_i)

        expect(@response_body_data["records"].last).to have_key("updated_at_date")
        expect(@response_body_data["records"].last["updated_at_date"]).to be_a(String)
        expect(DateTime.parse(@response_body_data["records"].last["updated_at_date"]).to_i).to be > 0
        expect(DateTime.parse(@response_body_data["records"].last["updated_at_date"]).to_i).to be < (Time.now.to_i)
    end
end