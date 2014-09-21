require 'rails_helper'

RSpec.describe "venues/index", :type => :view do
  before(:each) do
    assign(:venues, [
      Venue.create!(
        :club => nil,
        :name => "Name",
        :playing_day => "Playing Day",
        :playing_time => "Playing Time",
        :info => "MyText"
      ),
      Venue.create!(
        :club => nil,
        :name => "Name",
        :playing_day => "Playing Day",
        :playing_time => "Playing Time",
        :info => "MyText"
      )
    ])
  end

  it "renders a list of venues" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Playing Day".to_s, :count => 2
    assert_select "tr>td", :text => "Playing Time".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
