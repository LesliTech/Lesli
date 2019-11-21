require 'rails_helper'

RSpec.describe "locks/edit", type: :view do
  before(:each) do
    @lock = assign(:lock, Lock.create!())
  end

  it "renders the edit lock form" do
    render

    assert_select "form[action=?][method=?]", lock_path(@lock), "post" do
    end
  end
end
