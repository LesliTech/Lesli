require 'rails_helper'

RSpec.describe "template/variables/edit", type: :view do
  before(:each) do
    @template_variable = assign(:template_variable, Template::Variable.create!(
      field_name: "MyString",
      table_name: "MyString",
      alias: "MyString"
    ))
  end

  it "renders the edit template_variable form" do
    render

    assert_select "form[action=?][method=?]", template_variable_path(@template_variable), "post" do

      assert_select "input[name=?]", "template_variable[field_name]"

      assert_select "input[name=?]", "template_variable[table_name]"

      assert_select "input[name=?]", "template_variable[alias]"
    end
  end
end
