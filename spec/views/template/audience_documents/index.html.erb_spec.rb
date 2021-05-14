require 'rails_helper'

RSpec.describe "template/audience_documents/index", type: :view do
  before(:each) do
    assign(:template_audience_documents, [
      Template::AudienceDocument.create!(),
      Template::AudienceDocument.create!()
    ])
  end

  it "renders a list of template/audience_documents" do
    render
  end
end
