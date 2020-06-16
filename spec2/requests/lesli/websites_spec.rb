require 'rails_helper'

RSpec.describe "Websites", type: :request do

    describe "GET:/websites" do

        it "it render landing page" do
            get "/"
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq('text/html; charset=utf-8')
        end

    end 

end
