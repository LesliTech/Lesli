require 'rails_helper'

RSpec.describe "Lock::RolePrivileges", type: :request do
  describe "GET /lock/role_privileges" do
    it "works! (now write some real specs)" do
      get lock_role_privileges_path
      expect(response).to have_http_status(200)
    end
  end
end
