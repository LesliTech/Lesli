require 'rails_helper'

RSpec.describe "bell/emails/edit", type: :view do
  before(:each) do
    @bell_email = assign(:bell_email, Bell::Email.create!())
  end

  it "renders the edit bell_email form" do
    render

    assert_select "form[action=?][method=?]", bell_email_path(@bell_email), "post" do
    end
  end
end
