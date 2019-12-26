require 'rails_helper'

RSpec.describe "Websites", type: :request do

    describe "GET /websites" do

        it "does not render a different template" do
            get "/"
            expect(response).to have_http_status(200)
            expect(response).to render_template(:landing)
        end

    end 

end
