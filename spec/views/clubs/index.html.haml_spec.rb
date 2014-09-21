require 'rails_helper'

RSpec.describe "clubs/index", :type => :view do
  before(:each) do
    assign(:clubs, [
      Club.create!(
        :name => "Name",
        :abbrev => "Abbrev"
      ),
      Club.create!(
        :name => "Name",
        :abbrev => "Abbrev"
      )
    ])
  end

  it "renders a list of clubs" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Abbrev".to_s, :count => 2
  end
end
