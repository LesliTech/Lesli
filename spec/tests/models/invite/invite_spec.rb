require 'rails_helper'

RSpec.describe Invite, type: :model do
    
    it 'ensures email presence' do
        
        invite = Invite.new(full_name: Faker::Name.name, telephone: Faker::PhoneNumber.cell_phone, note: Faker::Lorem.sentence).save
        expect(invite).to eq(false) 
 
    end
    
    it 'ensures the fields have correct type' do
        
        invite = FactoryBot.build(:invite)
        
        puts invite.created_at.class
        
        expect(invite.full_name).to be_a_kind_of(String)
        expect(invite.note).to be_a_kind_of(String)
        expect(invite.status).to eql(nil)
        expect(invite.accounts_id).to eql(nil)
        expect(invite.deleted_at).to eql(nil)
        expect(invite.sent_at).to eql(nil)
        expect(invite.telephone).to be_a_kind_of(String)
        
    end
    
    it 'ensures telephone length to be correct' do
        
        invite = Invite.new(
            full_name:  Faker::Name.name,
            telephone: '232-67-987',
            note: Faker::Lorem.sentence
        )
        
        expect(invite.telephone.length).to be_eql(10)
        
    end
    
    it "is expects to return correct information" do
        
        invite = FactoryBot.build(:invite)
        full_name = invite.full_name
        telephone = invite.telephone
        email = invite.email
        note =  invite.note
        
        expect(invite.full_name).to eql(full_name)
        expect(invite.telephone).to eql(telephone)
        expect(invite.email).to eql(email)
        expect(invite.note).to eql(note)
        
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
