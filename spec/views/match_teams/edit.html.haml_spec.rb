require 'rails_helper'

RSpec.describe "match_teams/edit", :type => :view do
  before(:each) do
    @match_team = assign(:match_team, MatchTeam.create!(
      :match => nil,
      :team => nil
    ))
  end

  it "renders the edit match_team form" do
    render

    assert_select "form[action=?][method=?]", match_team_path(@match_team), "post" do

      assert_select "input#match_team_match_id[name=?]", "match_team[match_id]"

      assert_select "input#match_team_team_id[name=?]", "match_team[team_id]"
    end
  end
end
