require 'rails_helper'

RSpec.describe "games/index", :type => :view do
  before(:each) do
    assign(:games, [
      Game.create!(
        :match => nil,
        :black => nil,
        :white => nil,
        :black_points => "Black Points",
        :white_points => "White Points",
        :reason => "Reason"
      ),
      Game.create!(
        :match => nil,
        :black => nil,
        :white => nil,
        :black_points => "Black Points",
        :white_points => "White Points",
        :reason => "Reason"
      )
    ])
  end

  it "renders a list of games" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Black Points".to_s, :count => 2
    assert_select "tr>td", :text => "White Points".to_s, :count => 2
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
  end
end
