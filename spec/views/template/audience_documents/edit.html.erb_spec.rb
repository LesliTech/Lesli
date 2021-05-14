require 'rails_helper'

RSpec.describe "template/audience_documents/edit", type: :view do
  before(:each) do
    @template_audience_document = assign(:template_audience_document, Template::AudienceDocument.create!())
  end

  it "renders the edit template_audience_document form" do
    render

    assert_select "form[action=?][method=?]", template_audience_document_path(@template_audience_document), "post" do
    end
  end
end
