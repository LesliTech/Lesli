require 'rails_helper'

RSpec.describe "template/variables/show", type: :view do
  before(:each) do
    @template_variable = assign(:template_variable, Template::Variable.create!(
      field_name: "Field Name",
      table_name: "Table Name",
      alias: "Alias"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Field Name/)
    expect(rendered).to match(/Table Name/)
    expect(rendered).to match(/Alias/)
  end
end
