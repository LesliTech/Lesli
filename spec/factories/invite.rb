FactoryBot.define do
    
    factory :invite, class: "Invite" do
        full_name {Faker::Name.name}
        email {Faker::Internet.email}
        telephone {Faker::PhoneNumber.cell_phone}
        note {Faker::Lorem.sentence}
    end
    
    
end
