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


# include helpers, configuration & initializers for request tests
require "lesli_model_helper"


RSpec.describe "Model:User", type: :model do

    describe "UserGuard/user.has_role_with_default_path?" do 

        it "is expected to return the default path of the user roles" do

            # create the new user
            user = FactoryBot.create(:user)
            role_admin = FactoryBot.create(:role_with_default_path)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_limited.update(:object_level_permission => 100)
            role_limited.update(:default_path => "/path/to/100")

            user.user_roles.create({ role: role_limited })

            default_path = user.has_role_with_default_path?

            expect(default_path).not_to be_nil
            expect(default_path).to be_a(String)
            expect(default_path).to eql("/path/to/100")
        end

        it "is expected to return the default path of the user roles with path" do

            # create the new user
            user = FactoryBot.create(:user)
            role_admin = FactoryBot.create(:role_with_default_path)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_admin.update(:object_level_permission => 2147483647)
            role_admin.update(:default_path => nil)

            role_limited.update(:object_level_permission => 100)
            role_limited.update(:default_path => "/path/to/100")

            user.user_roles.create({ role: role_admin })
            user.user_roles.create({ role: role_limited })

            default_path = user.has_role_with_default_path?

            expect(default_path).not_to be_nil
            expect(default_path).to be_a(String)
            expect(default_path).to eql("/path/to/100")

        end

        it "is expected to return the default path of the highest user role" do

            # create the new user
            user = FactoryBot.create(:user)
            role_admin = FactoryBot.create(:role_with_default_path)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_admin.update(:object_level_permission => 2147483647)
            role_admin.update(:default_path => "/path/to/2147483647")

            role_limited.update(:object_level_permission => 100)
            role_limited.update(:default_path => "/path/to/100")

            user.user_roles.create({ role: role_admin })
            user.user_roles.create({ role: role_limited })

            default_path = user.has_role_with_default_path?

            expect(default_path).not_to be_nil
            expect(default_path).to be_a(String)
            expect(default_path).to eql("/path/to/2147483647")

        end

        it "is expected to return nil as the default path of the user role" do

            # create the new user
            user = FactoryBot.create(:user)
            default_path = user.has_role_with_default_path?
            expect(default_path).to be_nil

        end
    end


    describe "UserGuard/user.has_role_limited_to_path?" do 

        it "is expected to return the limited path of the user roles" do

            # create the new user
            user = FactoryBot.create(:user)
            user.user_roles.destroy_all
            role_limited = FactoryBot.create(:role_with_default_path)

            role_limited.update(:object_level_permission => 100)
            role_limited.update(:default_path => "/administration")
            role_limited.update(:limit_to_path => true)

            user.user_roles.create({ role: role_limited })

            limit_path = user.has_role_limited_to_path?

            expect(limit_path).not_to be_nil
            expect(limit_path).to be_a(String)
            expect(limit_path).to eql("/administration")
        end

        it "is expected to return nil as limited path of the user roles" do

            # create the new user
            user = FactoryBot.create(:user)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_limited.update(:object_level_permission => 100)
            role_limited.update(:default_path => "/administration")
            role_limited.update(:limit_to_path => nil)

            user.user_roles.create({ role: role_limited })

            limit_path = user.has_role_limited_to_path?

            expect(limit_path).to be_nil
        end

        it "is expected to return the limited path of the user roles" do

            # create the new user
            user = FactoryBot.create(:user)

            role_admin = FactoryBot.create(:role)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_admin.update(:object_level_permission => 1000)
            role_limited.update(:object_level_permission => 1000)
            role_limited.update(:default_path => "/administration")
            role_limited.update(:limit_to_path => true)

            user.user_roles.create({ role: role_admin })
            user.user_roles.create({ role: role_limited })

            limit_path = user.has_role_limited_to_path?

            expect(limit_path).not_to be_nil
            expect(limit_path).to be_a(String)
            expect(limit_path).to eql("/administration")
        end

        it "is expected to return the nil as highest role path" do

            # create the new user
            user = FactoryBot.create(:user)

            role_admin = FactoryBot.create(:role)
            role_limited = FactoryBot.create(:role_with_default_path)

            role_admin.update(:object_level_permission => 10000)
            role_limited.update(:object_level_permission => 1000)
            role_limited.update(:default_path => "/administration")
            role_limited.update(:limit_to_path => true)

            user.user_roles.create({ role: role_admin })
            user.user_roles.create({ role: role_limited })

            limit_path = user.has_role_limited_to_path?

            expect(limit_path).to be_nil
        end
    end
end
