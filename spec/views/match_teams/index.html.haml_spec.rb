require 'rails_helper'

RSpec.describe "match_teams/index", :type => :view do
  before(:each) do
    assign(:match_teams, [
      MatchTeam.create!(
        :match => nil,
        :team => nil
      ),
      MatchTeam.create!(
        :match => nil,
        :team => nil
      )
    ])
  end

  it "renders a list of match_teams" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
