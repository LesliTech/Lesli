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


RSpec.describe AccountLocationService, type: :model do
    describe "Check if AccountLocationService create the locations for a new account" do

        before(:all) do
            @new_account = create(:account)
        end

        it "is expected account has empty default location" do
            location = @new_account.locations.find_by(:name => "Empty")

            expect(location.blank?).to eq false
        end

        it "is expected account has continent Africa" do
            location = @new_account.locations.find_by(:name => "Africa")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

        it "is expected account has continent Asia" do
            location = @new_account.locations.find_by(:name => "Asia")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

        it "is expected account has continent Europe" do
            location = @new_account.locations.find_by(:name => "Europe")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

        it "is expected account has continent North America" do
            location = @new_account.locations.find_by(:name => "North America")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

        it "is expected account has continent Oceania" do
            location = @new_account.locations.find_by(:name => "Oceania")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

        it "is expected account has continent South America" do
            location = @new_account.locations.find_by(:name => "South America")

            expect(location.blank?).to eq false
            expect(location.level).to eq "continent"
        end

    end
end
