require 'rails_helper'

RSpec.describe "template/variables/index", type: :view do
  before(:each) do
    assign(:template_variables, [
      Template::Variable.create!(
        field_name: "Field Name",
        table_name: "Table Name",
        alias: "Alias"
      ),
      Template::Variable.create!(
        field_name: "Field Name",
        table_name: "Table Name",
        alias: "Alias"
      )
    ])
  end

  it "renders a list of template/variables" do
    render
    assert_select "tr>td", text: "Field Name".to_s, count: 2
    assert_select "tr>td", text: "Table Name".to_s, count: 2
    assert_select "tr>td", text: "Alias".to_s, count: 2
  end
end
