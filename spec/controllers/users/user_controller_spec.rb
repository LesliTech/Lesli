RSpec.describe "Users" do

    describe "total users in databae" do

        it "should return at least 1 user" do
            expect(User.all.size).to be >= 1
        end

    end

    describe "test user in database" do

        it "should return user for testing" do
            user = User.find_by(:email => "test@lesli.cloud2")
            expect(user[:email]).to eql("test@lesli.cloud")
        end

    end
    
end
