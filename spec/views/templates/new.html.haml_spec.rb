require 'rails_helper'

RSpec.describe "templates/new", type: :view do
  before(:each) do
    assign(:template, Template.new())
  end

  it "renders new template form" do
    render

    assert_select "form[action=?][method=?]", templates_path, "post" do
    end
  end
end
