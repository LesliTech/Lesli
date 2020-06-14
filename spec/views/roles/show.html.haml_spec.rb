require 'rails_helper'

RSpec.describe "roles/show", type: :view do
  before(:each) do
    @role = assign(:role, Role.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
