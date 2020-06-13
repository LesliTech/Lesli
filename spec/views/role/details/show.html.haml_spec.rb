require 'rails_helper'

RSpec.describe "role/details/show", type: :view do
  before(:each) do
    @role_detail = assign(:role_detail, Role::Detail.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
