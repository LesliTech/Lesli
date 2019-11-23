require 'rails_helper'

RSpec.describe "translations/edit", type: :view do
  before(:each) do
    @translation = assign(:translation, Translation.create!())
  end

  it "renders the edit translation form" do
    render

    assert_select "form[action=?][method=?]", translation_path(@translation), "post" do
    end
  end
end
