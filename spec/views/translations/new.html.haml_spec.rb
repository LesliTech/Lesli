require 'rails_helper'

RSpec.describe "translations/new", type: :view do
  before(:each) do
    assign(:translation, Translation.new())
  end

  it "renders new translation form" do
    render

    assert_select "form[action=?][method=?]", translations_path, "post" do
    end
  end
end
