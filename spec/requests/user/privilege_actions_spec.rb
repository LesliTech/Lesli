 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/user/privilege_actions", type: :request do
  # User::PrivilegeAction. As you add validations to User::PrivilegeAction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      User::PrivilegeAction.create! valid_attributes
      get user_privilege_actions_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      privilege_action = User::PrivilegeAction.create! valid_attributes
      get user_privilege_action_url(user_privilege_action)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    # it "renders a successful response" do
    #   get new_user_privilege_action_url
    #   expect(response).to be_successful
    # end
  end

  describe "GET /edit" do
    it "render a successful response" do
      privilege_action = User::PrivilegeAction.create! valid_attributes
      get edit_user_privilege_action_url(user_privilege_action)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    # context "with valid parameters" do
    #   it "creates a new User::PrivilegeAction" do
    #     expect {
    #       post user_privilege_actions_url, params: { user_privilege_action: valid_attributes }
    #     }.to change(User::PrivilegeAction, :count).by(1)
    #   end

    #   it "redirects to the created user_privilege_action" do
    #     post user_privilege_actions_url, params: { user_privilege_action: valid_attributes }
    #     expect(response).to redirect_to(user_privilege_action_url(@user_privilege_action))
    #   end
    # end

    # context "with invalid parameters" do
    #   it "does not create a new User::PrivilegeAction" do
    #     expect {
    #       post user_privilege_actions_url, params: { user_privilege_action: invalid_attributes }
    #     }.to change(User::PrivilegeAction, :count).by(0)
    #   end

    #   it "renders a successful response (i.e. to display the 'new' template)" do
    #     post user_privilege_actions_url, params: { user_privilege_action: invalid_attributes }
    #     expect(response).to be_successful
    #   end
    # end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested user_privilege_action" do
        privilege_action = User::PrivilegeAction.create! valid_attributes
        patch user_privilege_action_url(user_privilege_action), params: { user_privilege_action: new_attributes }
        privilege_action.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the user_privilege_action" do
        privilege_action = User::PrivilegeAction.create! valid_attributes
        patch user_privilege_action_url(user_privilege_action), params: { user_privilege_action: new_attributes }
        privilege_action.reload
        expect(response).to redirect_to(user_privilege_action_url(privilege_action))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        privilege_action = User::PrivilegeAction.create! valid_attributes
        patch user_privilege_action_url(user_privilege_action), params: { user_privilege_action: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested user_privilege_action" do
      privilege_action = User::PrivilegeAction.create! valid_attributes
      expect {
        delete user_privilege_action_url(user_privilege_action)
      }.to change(User::PrivilegeAction, :count).by(-1)
    end

    it "redirects to the user_privilege_actions list" do
      privilege_action = User::PrivilegeAction.create! valid_attributes
      delete user_privilege_action_url(user_privilege_action)
      expect(response).to redirect_to(user_privilege_actions_url)
    end
  end
end
