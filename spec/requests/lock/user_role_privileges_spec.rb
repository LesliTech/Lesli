require 'rails_helper'

RSpec.describe "Lock::UserRolePrivileges", type: :request do
  describe "GET /lock/user_role_privileges" do
    it "works! (now write some real specs)" do
      get lock_user_role_privileges_path
      expect(response).to have_http_status(200)
    end
  end
end
