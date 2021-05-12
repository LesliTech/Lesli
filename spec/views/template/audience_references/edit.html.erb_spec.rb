require 'rails_helper'

RSpec.describe "template/audience_references/edit", type: :view do
  before(:each) do
    @template_audience_reference = assign(:template_audience_reference, Template::AudienceReference.create!())
  end

  it "renders the edit template_audience_reference form" do
    render

    assert_select "form[action=?][method=?]", template_audience_reference_path(@template_audience_reference), "post" do
    end
  end
end
