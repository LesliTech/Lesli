require 'rails_helper'

RSpec.describe "lock/user_details/new", type: :view do
  before(:each) do
    assign(:lock_user_detail, Lock::UserDetail.new())
  end

  it "renders new lock_user_detail form" do
    render

    assert_select "form[action=?][method=?]", lock_user_details_path, "post" do
    end
  end
end
