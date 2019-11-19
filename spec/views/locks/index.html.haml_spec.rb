require 'rails_helper'

RSpec.describe "locks/index", type: :view do
  before(:each) do
    assign(:locks, [
      Lock.create!(),
      Lock.create!()
    ])
  end

  it "renders a list of locks" do
    render
  end
end
