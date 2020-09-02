require 'rails_helper'

RSpec.describe "template/documents/index", type: :view do
  before(:each) do
    assign(:template_documents, [
      Template::Document.create!(
        name: "Name",
        attachment: "Attachment",
        file_type: "File Type"
      ),
      Template::Document.create!(
        name: "Name",
        attachment: "Attachment",
        file_type: "File Type"
      )
    ])
  end

  it "renders a list of template/documents" do
    render
    assert_select "tr>td", text: "Name".to_s, count: 2
    assert_select "tr>td", text: "Attachment".to_s, count: 2
    assert_select "tr>td", text: "File Type".to_s, count: 2
  end
end
