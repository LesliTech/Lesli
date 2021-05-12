require 'rails_helper'

RSpec.describe "template/audiences/show", type: :view do
  before(:each) do
    @template_audience = assign(:template_audience, Template::Audience.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
