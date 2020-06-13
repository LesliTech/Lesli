require 'rails_helper'

RSpec.describe "role/details/new", type: :view do
  before(:each) do
    assign(:role_detail, Role::Detail.new())
  end

  it "renders new role_detail form" do
    render

    assert_select "form[action=?][method=?]", role_details_path, "post" do
    end
  end
end
