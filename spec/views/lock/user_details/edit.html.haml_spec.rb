require 'rails_helper'

RSpec.describe "lock/user_details/edit", type: :view do
  before(:each) do
    @lock_user_detail = assign(:lock_user_detail, Lock::UserDetail.create!())
  end

  it "renders the edit lock_user_detail form" do
    render

    assert_select "form[action=?][method=?]", lock_user_detail_path(@lock_user_detail), "post" do
    end
  end
end
