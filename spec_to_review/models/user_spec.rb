require "rails_helper"
require "spec_helper"
require "byebug"
require "faker"

RSpec.describe "using method (clear_fields) based on a list of specific fields", type: :model do
    account = User.first.account # instance of account

    # user variables
    password = Faker::Internet.password
    first_name = Faker::Name.last_name
    last_name = Faker::Name.last_name
    salutation = ["mr", "mrs"][rand(2)]
    address = Faker::Address.city

    # create user
    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: first_name,
            last_name: last_name,
            salutation: salutation,
            address: address
        }
    })


    user.detail.clear_fields(["first_name", "last_name"])

    it "clear only specific fields where clean" do
        expect(user.detail.first_name).to   eql(nil)
        expect(user.detail.last_name).to    eql(nil)
        expect(user.detail.salutation).to   eql(salutation)
        expect(user.detail.address).to      eql(address)
    end
end


RSpec.describe "using method (clear_fields) to clear all fields excluding foreign key", type: :model do
    account = User.first.account # instance of account

    # create user
    password = Faker::Internet.password

    user = account.users.create({
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        detail_attributes: {
            first_name: Faker::Name.last_name,
            last_name: Faker::Name.last_name,
            salutation: ["mr", "mrs"][rand(2)],
            address: Faker::Address.city
        }
    })


    user.detail.clear_fields

    it "clear all fields excluding foreign keys" do
        user.detail.attributes.each do |key, value|
            next if (key.end_with? "id") ||
            key == "created_at" ||
            key == "updated_at" ||
            key == "deleted_at"

            expect(value).to eql(nil)
        end
    end
end


RSpec.describe "using method (full_name_initials)", type: :model do
    account = User.first.account # instance of account

    # create user
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

    it "Initials match" do

        first_name_initial = first_name[0].upcase
        last_name_initial = last_name[0].upcase

        expect(user.full_name_initials).to  eql("#{first_name_initial}#{last_name_initial}")
    end
end

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
