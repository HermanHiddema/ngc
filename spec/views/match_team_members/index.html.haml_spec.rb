require 'rails_helper'

RSpec.describe "match_team_members/index", :type => :view do
  before(:each) do
    assign(:match_team_members, [
      MatchTeamMember.create!(
        :match_team => nil,
        :team_member => nil
      ),
      MatchTeamMember.create!(
        :match_team => nil,
        :team_member => nil
      )
    ])
  end

  it "renders a list of match_team_members" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
