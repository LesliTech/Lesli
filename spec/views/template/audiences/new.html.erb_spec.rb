require 'rails_helper'

RSpec.describe "template/audiences/new", type: :view do
  before(:each) do
    assign(:template_audience, Template::Audience.new())
  end

  it "renders new template_audience form" do
    render

    assert_select "form[action=?][method=?]", template_audiences_path, "post" do
    end
  end
end
