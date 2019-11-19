require 'rails_helper'

RSpec.describe "Lock::UserPrivileges", type: :request do
  describe "GET /lock/user_privileges" do
    it "works! (now write some real specs)" do
      get lock_user_privileges_path
      expect(response).to have_http_status(200)
    end
  end
end
