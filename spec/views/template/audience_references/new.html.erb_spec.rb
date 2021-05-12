require 'rails_helper'

RSpec.describe "template/audience_references/new", type: :view do
  before(:each) do
    assign(:template_audience_reference, Template::AudienceReference.new())
  end

  it "renders new template_audience_reference form" do
    render

    assert_select "form[action=?][method=?]", template_audience_references_path, "post" do
    end
  end
end
