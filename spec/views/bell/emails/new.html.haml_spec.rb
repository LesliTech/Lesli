require 'rails_helper'

RSpec.describe "bell/emails/new", type: :view do
  before(:each) do
    assign(:bell_email, Bell::Email.new())
  end

  it "renders new bell_email form" do
    render

    assert_select "form[action=?][method=?]", bell_emails_path, "post" do
    end
  end
end
