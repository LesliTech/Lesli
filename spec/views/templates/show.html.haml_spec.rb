require 'rails_helper'

RSpec.describe "templates/show", type: :view do
  before(:each) do
    @template = assign(:template, Template.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
