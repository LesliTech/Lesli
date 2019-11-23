require 'rails_helper'

RSpec.describe "translations/show", type: :view do
  before(:each) do
    @translation = assign(:translation, Translation.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
