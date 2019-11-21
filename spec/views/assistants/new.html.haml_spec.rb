require 'rails_helper'

RSpec.describe "assistants/new", type: :view do
  before(:each) do
    assign(:assistant, Assistant.new())
  end

  it "renders new assistant form" do
    render

    assert_select "form[action=?][method=?]", assistants_path, "post" do
    end
  end
end
