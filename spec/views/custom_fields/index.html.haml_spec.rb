require 'rails_helper'

RSpec.describe "custom_fields/index", type: :view do
  before(:each) do
    assign(:custom_fields, [
      CustomField.create!(),
      CustomField.create!()
    ])
  end

  it "renders a list of custom_fields" do
    render
  end
end
