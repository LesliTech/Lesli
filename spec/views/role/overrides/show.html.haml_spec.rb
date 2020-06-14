require 'rails_helper'

RSpec.describe "role/overrides/show", type: :view do
  before(:each) do
    @role_override = assign(:role_override, Role::Override.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
