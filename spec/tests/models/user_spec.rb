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

    it "is expected to clear only specific fields of user" do

        # create user
        user = FactoryBot.create(:user)

        # clear fields
        user.detail.clear_fields(["first_name", "last_name"])

        expect(user.detail.first_name).to eql(nil)
        expect(user.detail.last_name).to eql(nil)
        expect(user.detail.salutation).to be_a_kind_of(String)
        expect(user.detail.address).to be_a_kind_of(String)
    end

    it "is expected to clear all fields excluding foreign key" do

        # create user
        user = FactoryBot.create(:user)

        # clear all fields
        user.detail.clear_fields

        expect(user.id).to be_a_kind_of(Integer)

        user.detail.attributes.each do |key, value|
            next if (key.end_with? "id") ||
            key == "created_at" ||
            key == "updated_at" ||
            key == "deleted_at"

            expect(value).to eql(nil)
        end

    end  
    
    it "is expected return user initials" do

        # create user
        user = FactoryBot.create(:user)

        first_name_initial = user.detail.first_name[0].upcase
        last_name_initial = user.detail.last_name[0].upcase

        expect(user.full_name_initials).to eql("#{first_name_initial}#{last_name_initial}")

    end  

    it "is is expected to return the abilities_by_controller defaults by the user" do
        # Create user with the sysadmin role by default
        # The sysadmin role has full access to the system, so there must exist the respective descriptors
        user = FactoryBot.create(:user)

        # Custom specs

        # Check if the user model responds to the call of the abilities_by_controller method
        expect(user).to respond_to(:abilities_by_controller)

        # Saving the response of the abilities_by_controller call and then execute specifications
        abilities_by_controller = user.abilities_by_controller
        
        expect(abilities_by_controller).to be_a(Hash)
        expect(abilities_by_controller.size).to be > 0
        expect(abilities_by_controller[abilities_by_controller.keys.first]).to be_an(Array)
        expect(abilities_by_controller[abilities_by_controller.keys.first]).not_to be_empty
        expect(abilities_by_controller[abilities_by_controller.keys.first].first).to be_a(String)

        # Check if in reality the privilege exists
        expect(
            user.privileges.find_by(
                :controller => abilities_by_controller.keys.first, 
                :action => abilities_by_controller[abilities_by_controller.keys.first].first
            )
        ).not_to be_nil
    end
end

=begin
RSpec.describe "using method (has_privileges?) to validate if a user has privileges through the role", type: :model do
    account = User.first.account # instance of account

    # ============ create user =============
    first_name = Faker::Name.last_name
    last_name = Faker::Name.last_name
    password = Faker::Internet.password

    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: first_name,
            last_name: last_name,
            salutation: ["mr", "mrs"][rand(2)],
            address: Faker::Address.city
        }
    })
    # ======================================

    # =========== create role ==============
    role = User.first.account.roles.create(
        active: true,
        name: Faker::Artist.name,
        object_level_permission: account.roles.map(&:object_level_permission).min()
    )

    # ======================================

    # ======= create a descriptor and assign privileges =======
    descriptor = account.role_descriptors.find_or_create_by(
        name: Faker::Artist.name
    ) # descriptor creation

    # add actions to the role descriptor

    system_actions = SystemController::Action.order(:id)
    limit_index = rand(50..(system_actions.count - 1))

    system_actions = system_actions[(limit_index-50)..(limit_index - 1)] # fetch 50 privilege actions

    categories = RoleDescriptor::PrivilegeAction.categories.map{|_k,v| v}
    category = categories[rand(categories.length)]

    system_actions.each do |system_action|
        descriptor.privilege_actions.find_or_create_by(
            system_action: system_action,
            category: category,
            status: true
        )
    end

    # ========================================================

    # create the descriptor assignment using a random category
    role.descriptor_assignments.find_or_create_by(
        descriptor: descriptor,
        category: category
    )

    user.user_roles.create({ role: role })

    system_actions = system_actions.concat(
        SystemController::Action.joins(:system_controller).order(:id)[0..19]
    ) # add 20 privilege actions

    # validate if a user has enable the controller action on a specific category
    it "Validate privilege actions of the role assigned to the user" do
        system_actions.each do |action|
            granted = user.has_privileges?([action.system_controller.name], [action.name])

            expect(granted).to eq(user.role_privilege_actions.find_by(system_action: action, category: category, status: true).present?)
        end
    end
end
=end
