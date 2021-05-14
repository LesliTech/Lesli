require 'rails_helper'

RSpec.describe "template/audience_documents/show", type: :view do
  before(:each) do
    @template_audience_document = assign(:template_audience_document, Template::AudienceDocument.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
