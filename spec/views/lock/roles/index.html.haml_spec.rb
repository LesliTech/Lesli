require 'rails_helper'

RSpec.describe "lock/roles/index", type: :view do
  before(:each) do
    assign(:lock_roles, [
      Lock::Role.create!(),
      Lock::Role.create!()
    ])
  end

  it "renders a list of lock/roles" do
    render
  end
end
