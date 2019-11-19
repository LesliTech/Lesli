require 'rails_helper'

RSpec.describe "locks/show", type: :view do
  before(:each) do
    @lock = assign(:lock, Lock.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
