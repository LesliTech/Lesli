require 'rails_helper'

RSpec.describe "template/mappings/edit", type: :view do
  before(:each) do
    @template_mapping = assign(:template_mapping, Template::Mapping.create!())
  end

  it "renders the edit template_mapping form" do
    render

    assert_select "form[action=?][method=?]", template_mapping_path(@template_mapping), "post" do
    end
  end
end
