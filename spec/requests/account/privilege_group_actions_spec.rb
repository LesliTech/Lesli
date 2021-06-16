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

RSpec.describe "/account/privilege_group_actions", type: :request do
  # Account::PrivilegeGroupAction. As you add validations to Account::PrivilegeGroupAction, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Account::PrivilegeGroupAction.create! valid_attributes
      get account_privilege_group_actions_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
      get account_privilege_group_action_url(account_privilege_group_action)
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
      get edit_account_privilege_group_action_url(account_privilege_group_action)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Account::PrivilegeGroupAction" do
        expect {
          post account_privilege_group_actions_url, params: { account_privilege_group_action: valid_attributes }
        }.to change(Account::PrivilegeGroupAction, :count).by(1)
      end

      it "redirects to the created account_privilege_group_action" do
        post account_privilege_group_actions_url, params: { account_privilege_group_action: valid_attributes }
        expect(response).to redirect_to(account_privilege_group_action_url(@account_privilege_group_action))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Account::PrivilegeGroupAction" do
        expect {
          post account_privilege_group_actions_url, params: { account_privilege_group_action: invalid_attributes }
        }.to change(Account::PrivilegeGroupAction, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post account_privilege_group_actions_url, params: { account_privilege_group_action: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested account_privilege_group_action" do
        privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
        patch account_privilege_group_action_url(account_privilege_group_action), params: { account_privilege_group_action: new_attributes }
        privilege_group_action.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the account_privilege_group_action" do
        privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
        patch account_privilege_group_action_url(account_privilege_group_action), params: { account_privilege_group_action: new_attributes }
        privilege_group_action.reload
        expect(response).to redirect_to(account_privilege_group_action_url(privilege_group_action))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
        patch account_privilege_group_action_url(account_privilege_group_action), params: { account_privilege_group_action: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested account_privilege_group_action" do
      privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
      expect {
        delete account_privilege_group_action_url(account_privilege_group_action)
      }.to change(Account::PrivilegeGroupAction, :count).by(-1)
    end

    it "redirects to the account_privilege_group_actions list" do
      privilege_group_action = Account::PrivilegeGroupAction.create! valid_attributes
      delete account_privilege_group_action_url(account_privilege_group_action)
      expect(response).to redirect_to(account_privilege_group_actions_url)
    end
  end
end
