require 'rails_helper'

RSpec.describe "template/audience_files/edit", type: :view do
  before(:each) do
    @template_audience_file = assign(:template_audience_file, Template::AudienceFile.create!())
  end

  it "renders the edit template_audience_file form" do
    render

    assert_select "form[action=?][method=?]", template_audience_file_path(@template_audience_file), "post" do
    end
  end
end
