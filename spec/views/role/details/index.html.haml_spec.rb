require 'rails_helper'

RSpec.describe "role/details/index", type: :view do
  before(:each) do
    assign(:role_details, [
      Role::Detail.create!(),
      Role::Detail.create!()
    ])
  end

  it "renders a list of role/details" do
    render
  end
end
