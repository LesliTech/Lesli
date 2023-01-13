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
require "rails_helper"

RSpec.describe Notifications::Sms, :type => :job do

    it "should return telephone and message" do
        telephone_number = "+502 58159520"
        message = Faker::Lorem.sentence

        validated_data = Notifications::Sms.validate(telephone_number, message)

        expect(validated_data[:telephone]).to eq(telephone_number)
        expect(validated_data[:message]).to eq(message)
    end

    it "should return telephone and message without spaces" do
        telephone_number = "    +49 123456789  "
        message = "    #{Faker::Lorem.sentence}   "

        validated_data = Notifications::Sms.validate(telephone_number, message)

        expect(validated_data[:telephone]).to eq(telephone_number.strip)
        expect(validated_data[:message]).to eq(message.strip)
    end

    it "should return ArgumentError if telephone does not have a country code" do
        telephone_number = "123456789"
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if telephone does not have '+' at the beginning" do
        telephone_number = "49 123456789"
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if telephone has letters" do
        telephone_number = "+49 z23d56d89a"
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if telephone is nil" do
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(nil, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if telephone is empty" do
        telephone_number = ""
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if only country code is given" do
        telephone_number = "+49"
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if telephone number is too long" do
        telephone_number = "+502 45454545454545454545"
        message = Faker::Lorem.sentence

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if message is nil" do
        telephone_number = "+49 123456789"

        expect { Notifications::Sms.validate(telephone_number, nil) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if message is empty" do
        telephone_number = "+49 123456789"
        message = ""

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end

    it "should return ArgumentError if message is too long" do
        telephone_number = "+49 123456789"
        message = "a" * 101

        expect { Notifications::Sms.validate(telephone_number, message) }.to raise_error(ArgumentError)
    end
end
