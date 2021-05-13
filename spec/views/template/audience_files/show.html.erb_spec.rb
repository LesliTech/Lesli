require 'rails_helper'

RSpec.describe "template/audience_files/show", type: :view do
  before(:each) do
    @template_audience_file = assign(:template_audience_file, Template::AudienceFile.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
