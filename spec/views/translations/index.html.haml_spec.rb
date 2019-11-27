require 'rails_helper'

RSpec.describe "translations/index", type: :view do
  before(:each) do
    assign(:translations, [
      Translation.create!(),
      Translation.create!()
    ])
  end

  it "renders a list of translations" do
    render
  end
end
