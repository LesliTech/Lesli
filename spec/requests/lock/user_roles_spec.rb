require 'rails_helper'

RSpec.describe "Lock::UserRoles", type: :request do
  describe "GET /lock/user_roles" do
    it "works! (now write some real specs)" do
      get lock_user_roles_path
      expect(response).to have_http_status(200)
    end
  end
end
