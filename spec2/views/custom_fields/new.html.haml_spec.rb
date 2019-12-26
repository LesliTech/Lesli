require 'rails_helper'

RSpec.describe "custom_fields/new", type: :view do
  before(:each) do
    assign(:custom_field, CustomField.new())
  end

  it "renders new custom_field form" do
    render

    assert_select "form[action=?][method=?]", custom_fields_path, "post" do
    end
  end
end
