require "lesli_request_helper"

RSpec.describe "InvitesController " do
    
    describe "Get:/invite", type: :request do
        
        include_context "request user authentication"
        
        it "returns a successfull response" do
            get("/invite")
            expect(response).to have_http_status(:ok)
            expect(response.status).to eq(200)
        end
        
        it "returns a content type to be text/html" do
            get("/invite")
            expect(response.content_type).to eq "text/html; charset=utf-8"
        end
        
        it "renders a right template" do
            get("/invite")
            expect(response).to render_template(:show)
        end
        
        it "does not render a different template" do
            get("/invite")
            expect(response).to_not render_template(:post)
        end  
        
    end  
    
end