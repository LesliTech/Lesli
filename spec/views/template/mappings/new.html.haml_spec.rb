require 'rails_helper'

RSpec.describe "template/mappings/new", type: :view do
  before(:each) do
    assign(:template_mapping, Template::Mapping.new())
  end

  it "renders new template_mapping form" do
    render

    assert_select "form[action=?][method=?]", template_mappings_path, "post" do
    end
  end
end
