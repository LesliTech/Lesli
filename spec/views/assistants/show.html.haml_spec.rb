require 'rails_helper'

RSpec.describe "assistants/show", type: :view do
  before(:each) do
    @assistant = assign(:assistant, Assistant.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
