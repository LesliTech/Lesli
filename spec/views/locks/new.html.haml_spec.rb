require 'rails_helper'

RSpec.describe "locks/new", type: :view do
  before(:each) do
    assign(:lock, Lock.new())
  end

  it "renders new lock form" do
    render

    assert_select "form[action=?][method=?]", locks_path, "post" do
    end
  end
end
