require 'rails_helper'

RSpec.describe "roles/new", type: :view do
  before(:each) do
    assign(:role, Role.new())
  end

  it "renders new role form" do
    render

    assert_select "form[action=?][method=?]", roles_path, "post" do
    end
  end
end
