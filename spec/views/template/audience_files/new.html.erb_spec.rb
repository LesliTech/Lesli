require 'rails_helper'

RSpec.describe "template/audience_files/new", type: :view do
  before(:each) do
    assign(:template_audience_file, Template::AudienceFile.new())
  end

  it "renders new template_audience_file form" do
    render

    assert_select "form[action=?][method=?]", template_audience_files_path, "post" do
    end
  end
end
