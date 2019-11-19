require 'rails_helper'

RSpec.describe "lock/user_details/show", type: :view do
  before(:each) do
    @lock_user_detail = assign(:lock_user_detail, Lock::UserDetail.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
