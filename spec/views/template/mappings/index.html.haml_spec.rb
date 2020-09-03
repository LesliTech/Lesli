require 'rails_helper'

RSpec.describe "template/mappings/index", type: :view do
  before(:each) do
    assign(:template_mappings, [
      Template::Mapping.create!(),
      Template::Mapping.create!()
    ])
  end

  it "renders a list of template/mappings" do
    render
  end
end
