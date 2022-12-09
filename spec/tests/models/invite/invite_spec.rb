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


require 'rails_helper'

RSpec.describe Invite, type: :model do
    
    it 'should not save successfully without an email' do
        
        invite = Invite.new(full_name: Faker::Name.name, telephone: Faker::PhoneNumber.cell_phone, note: Faker::Lorem.sentence).save
        expect(invite).to eq(false) 
 
    end
    
    it 'ensures the fields have correct type' do
        
        invite = FactoryBot.build(:invite)
        
        expect(invite.full_name).to be_a_kind_of(String)
        expect(invite.note).to be_a_kind_of(String)
        expect(invite.status).to eql(nil)
        expect(invite.deleted_at).to eql(nil)
        expect(invite.sent_at).to eql(nil)
        expect(invite.telephone).to be_a_kind_of(String)
        
    end
    
    it 'ensures telephone length to be correct' do
        
        invite = Invite.new(
            full_name:  Faker::Name.name,
            telephone: Faker::PhoneNumber.subscriber_number(length: 10),
            note: Faker::Lorem.sentence
        )
        
        expect(invite.telephone.length).to be_eql(10)
        
    end
    
    it  'should save successfully' do
        invite = Invite.new(
            full_name: Faker::Name.name,
            email: Faker::Internet.email,
            telephone: Faker::PhoneNumber.cell_phone
        ).save
        expect(invite).to eq(true) 
    end
    
end
