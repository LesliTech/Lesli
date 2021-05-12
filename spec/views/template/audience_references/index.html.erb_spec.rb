require 'rails_helper'

RSpec.describe "template/audience_references/index", type: :view do
  before(:each) do
    assign(:template_audience_references, [
      Template::AudienceReference.create!(),
      Template::AudienceReference.create!()
    ])
  end

  it "renders a list of template/audience_references" do
    render
  end
end
