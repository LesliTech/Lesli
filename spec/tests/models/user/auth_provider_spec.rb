=begin

Copyright (c) 2022, all rights reserved.

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


# include helpers, configuration & initializers for request tests
require "lesli_model_helper"


RSpec.describe "Model:User::AuthProvider", type: :model do

    it "is expected to create a user random auth provider" do

        # Creating user to be independent from other tests
        user = FactoryBot.create(:user)

        # Using faker to generate random provider
        sample_provider = Faker::Internet.domain_word
        sample_uid = Faker::Internet.uuid

        # Create user auth provider
        user.auth_providers.create({
            provider: sample_provider,
            uid: sample_uid,
        })

        # Looking for the user auth provider just created
        sample_auth_provider = user.auth_providers.find_by(provider: sample_provider)

        # Expectations
        expect(sample_auth_provider).to be_present
        expect(sample_auth_provider.provider).to eq(sample_provider)
        expect(sample_auth_provider.uid).to eq(sample_uid)
    end

    it "is expected to create a user google auth provider" do

        # Creating user to be independent from other tests
        user = FactoryBot.create(:user)

        # Using Google as provider with a random uid
        sample_provider = 'Google'
        sample_uid = Faker::Internet.uuid

        # Create user auth provider
        user.auth_providers.create({
            provider: sample_provider,
            uid: sample_uid,
        })

        # Looking for the user auth provider just created
        sample_auth_provider = user.auth_providers.find_by(provider: sample_provider)

        # Expectations
        expect(sample_auth_provider).to be_present
        expect(sample_auth_provider.provider).to eq(sample_provider)
        expect(sample_auth_provider.uid).to eq(sample_uid)

        # If defined CloudDriver and provider is Google, it is expected to create a calendar to enable sync of events
        if defined? CloudDriver
            auth_provider_calendar = user.account.driver.calendars.find_by(
                user_main: user,
                user_creator: user,
                source_code: 'google',
            )

            expect(auth_provider_calendar).to be_present
            expect(auth_provider_calendar.source_code).to eq('google')
        end
    end

end
