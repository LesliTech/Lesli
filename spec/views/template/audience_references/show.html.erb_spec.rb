require 'rails_helper'

RSpec.describe "template/audience_references/show", type: :view do
  before(:each) do
    @template_audience_reference = assign(:template_audience_reference, Template::AudienceReference.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
