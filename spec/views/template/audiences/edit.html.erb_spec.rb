require 'rails_helper'

RSpec.describe "template/audiences/edit", type: :view do
  before(:each) do
    @template_audience = assign(:template_audience, Template::Audience.create!())
  end

  it "renders the edit template_audience form" do
    render

    assert_select "form[action=?][method=?]", template_audience_path(@template_audience), "post" do
    end
  end
end
