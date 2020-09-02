require 'rails_helper'

RSpec.describe "template/documents/new", type: :view do
  before(:each) do
    assign(:template_document, Template::Document.new(
      name: "MyString",
      attachment: "MyString",
      file_type: "MyString"
    ))
  end

  it "renders new template_document form" do
    render

    assert_select "form[action=?][method=?]", template_documents_path, "post" do

      assert_select "input[name=?]", "template_document[name]"

      assert_select "input[name=?]", "template_document[attachment]"

      assert_select "input[name=?]", "template_document[file_type]"
    end
  end
end
