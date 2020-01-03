require 'rails_helper'

RSpec.describe WebsitesController, type: :controller do

    describe "GET /websites" do
        it "responds successfully with an HTTP 200 status code" do
            get :landing
            expect(response.status).to eq(200)
        end
    end

end
