require 'rails_helper'

RSpec.describe "template/audience_documents/new", type: :view do
  before(:each) do
    assign(:template_audience_document, Template::AudienceDocument.new())
  end

  it "renders new template_audience_document form" do
    render

    assert_select "form[action=?][method=?]", template_audience_documents_path, "post" do
    end
  end
end
