require 'rails_helper'

RSpec.describe "roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(),
      Role.create!()
    ])
  end

  it "renders a list of roles" do
    render
  end
end
