require 'rails_helper'

RSpec.describe "template/mappings/show", type: :view do
  before(:each) do
    @template_mapping = assign(:template_mapping, Template::Mapping.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
