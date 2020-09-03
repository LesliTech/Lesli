require 'rails_helper'

RSpec.describe "templates/index", type: :view do
  before(:each) do
    assign(:templates, [
      Template.create!(),
      Template.create!()
    ])
  end

  it "renders a list of templates" do
    render
  end
end
