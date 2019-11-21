require 'rails_helper'

RSpec.describe "assistants/edit", type: :view do
  before(:each) do
    @assistant = assign(:assistant, Assistant.create!())
  end

  it "renders the edit assistant form" do
    render

    assert_select "form[action=?][method=?]", assistant_path(@assistant), "post" do
    end
  end
end
