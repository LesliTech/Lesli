require 'rails_helper'

RSpec.describe "template/variables/new", type: :view do
  before(:each) do
    assign(:template_variable, Template::Variable.new(
      field_name: "MyString",
      table_name: "MyString",
      alias: "MyString"
    ))
  end

  it "renders new template_variable form" do
    render

    assert_select "form[action=?][method=?]", template_variables_path, "post" do

      assert_select "input[name=?]", "template_variable[field_name]"

      assert_select "input[name=?]", "template_variable[table_name]"

      assert_select "input[name=?]", "template_variable[alias]"
    end
  end
end
