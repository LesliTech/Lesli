require 'rails_helper'

RSpec.describe "template/documents/edit", type: :view do
  before(:each) do
    @template_document = assign(:template_document, Template::Document.create!(
      name: "MyString",
      attachment: "MyString",
      file_type: "MyString"
    ))
  end

  it "renders the edit template_document form" do
    render

    assert_select "form[action=?][method=?]", template_document_path(@template_document), "post" do

      assert_select "input[name=?]", "template_document[name]"

      assert_select "input[name=?]", "template_document[attachment]"

      assert_select "input[name=?]", "template_document[file_type]"
    end
  end
end
