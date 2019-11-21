require 'rails_helper'

RSpec.describe "bell/emails/index", type: :view do
  before(:each) do
    assign(:bell_emails, [
      Bell::Email.create!(),
      Bell::Email.create!()
    ])
  end

  it "renders a list of bell/emails" do
    render
  end
end
