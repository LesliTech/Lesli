require 'rails_helper'

RSpec.describe "role/details/edit", type: :view do
  before(:each) do
    @role_detail = assign(:role_detail, Role::Detail.create!())
  end

  it "renders the edit role_detail form" do
    render

    assert_select "form[action=?][method=?]", role_detail_path(@role_detail), "post" do
    end
  end
end
