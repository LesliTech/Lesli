require 'rails_helper'

RSpec.describe "lock/roles/show", type: :view do
  before(:each) do
    @lock_role = assign(:lock_role, Lock::Role.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
