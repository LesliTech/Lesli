require 'rails_helper'

RSpec.describe "bell/emails/show", type: :view do
  before(:each) do
    @bell_email = assign(:bell_email, Bell::Email.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
