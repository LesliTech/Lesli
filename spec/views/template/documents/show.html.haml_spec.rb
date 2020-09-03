require 'rails_helper'

RSpec.describe "template/documents/show", type: :view do
  before(:each) do
    @template_document = assign(:template_document, Template::Document.create!(
      name: "Name",
      attachment: "Attachment",
      file_type: "File Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Attachment/)
    expect(rendered).to match(/File Type/)
  end
end
