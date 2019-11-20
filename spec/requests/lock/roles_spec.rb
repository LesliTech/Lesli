require 'rails_helper'

RSpec.describe "Lock::Roles", type: :request do
  describe "GET /lock/roles" do
    it "works! (now write some real specs)" do
      get lock_roles_path
      expect(response).to have_http_status(200)
    end
  end
end
