require 'rails_helper'

RSpec.describe "match_teams/new", :type => :view do
  before(:each) do
    assign(:match_team, MatchTeam.new(
      :match => nil,
      :team => nil
    ))
  end

  it "renders new match_team form" do
    render

    assert_select "form[action=?][method=?]", match_teams_path, "post" do

      assert_select "input#match_team_match_id[name=?]", "match_team[match_id]"

      assert_select "input#match_team_team_id[name=?]", "match_team[team_id]"
    end
  end
end
