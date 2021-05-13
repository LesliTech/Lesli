require 'rails_helper'

RSpec.describe "template/audience_files/index", type: :view do
  before(:each) do
    assign(:template_audience_files, [
      Template::AudienceFile.create!(),
      Template::AudienceFile.create!()
    ])
  end

  it "renders a list of template/audience_files" do
    render
  end
end
