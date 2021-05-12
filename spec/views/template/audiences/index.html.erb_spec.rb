require 'rails_helper'

RSpec.describe "template/audiences/index", type: :view do
  before(:each) do
    assign(:template_audiences, [
      Template::Audience.create!(),
      Template::Audience.create!()
    ])
  end

  it "renders a list of template/audiences" do
    render
  end
end
