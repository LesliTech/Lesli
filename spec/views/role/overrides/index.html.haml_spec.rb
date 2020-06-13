require 'rails_helper'

RSpec.describe "role/overrides/index", type: :view do
  before(:each) do
    assign(:role_overrides, [
      Role::Override.create!(),
      Role::Override.create!()
    ])
  end

  it "renders a list of role/overrides" do
    render
  end
end
