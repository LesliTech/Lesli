

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

RSpec.describe Courier::Bell::Notification, type: :model do

    before(:all) do
        return unless defined? CloudBell

        @account = User.find_by(email: Rails.application.config.lesli_settings["account"]["user"]["email"]).account # instance of account

        # create user
        password = Faker::Internet.password
        @user = @account.users.create({
            email: Faker::Internet.email,
            password: password,
            password_confirmation: password,
            detail_attributes: {
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                salutation: ["mr", "mrs"][rand(2)],
                address: Faker::Address.city
            }
        })
    end

    it "Courier::Bell::Notification.count" do
        expect(Courier::Bell::Notification.count(@user)).to eq(@account.bell.notifications.count)
    end

    it "Courier::Bell::Notification.index" do
        notifications =  Courier::Bell::Notification.index(@user, query())

        # check pagination
        expect(notifications[:pagination][:count_total]).to eq(@account.bell.notifications.count)
        expect(notifications[:pagination][:current_page]).to eq(query()[:pagination][:page])
        expect(notifications[:pagination][:count_results]).to eq(query()[:pagination][:perPage])

        # check data
        expect(notifications[:records].class).to eq(Array)
    end

    it "Courier::Bell::Notification.read" do
        notification = @account.bell.notifications.create(
            user: @user,
            subject: Faker::Lorem.word,
            body: Faker::Lorem.sentence,
            url: Faker::Internet.url,
            category: "info",
            channel: "web",
            status: "created"
        )


        # call read method
        CloudBell::Notification.read(User.first,  notification.id)

        expect(CloudBell::Notification.find_by(id: notification.id).status).to eq(CloudBell::Notification.statuses[:read])
    end

    it "Courier::Bell::Notification.new" do
        notification = Courier::Bell::Notification.new(
            @user,
            Faker::Lorem.word,
            body: Faker::Lorem.sentence,
            url: Faker::Internet.url,
            category: "info",
            channel: "web"
        )

        expect(notification[:id]&.last).to be >= 0
    end

    private

    def query()
        @query = {
            filters: {},
            pagination: {
                perPage: 15,
                page: 1,
                order: "desc",
                orderColumn: "id"
            }
        }
    end

    def random_channel()
        channels = CloudBell::Notification.channels

        return channels[rand(channels.length)]
    end

    def random_category()
        categories = CloudBell::Notification.categories

        return categories[rand(categories.length)]
    end
end
