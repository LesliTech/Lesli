require 'rails_helper'

RSpec.describe "lock/user_details/index", type: :view do
  before(:each) do
    assign(:lock_user_details, [
      Lock::UserDetail.create!(),
      Lock::UserDetail.create!()
    ])
  end

  it "renders a list of lock/user_details" do
    render
  end
end
