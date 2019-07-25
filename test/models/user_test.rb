require 'test_helper'

class UserTest < ActiveSupport::TestCase
    test "should not save empty user" do
        model = User.new
        assert_not model.save
    end
    test "should not save user without password" do
        model = User.new
        model.email = 'test@lesli.dev'
        assert_not model.save
    end
    test "should create a new user" do
        model = User.new
        model.email = 'test@lesli.dev'
        model.password = 'lesli2019'
        model.password_confirmation = 'lesli2020'
        assert_not model.save
    end
end

