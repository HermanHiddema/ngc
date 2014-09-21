require 'rails_helper'

RSpec.describe "matches/index", :type => :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :league => nil
      ),
      Match.create!(
        :league => nil
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
