require 'rails_helper'

RSpec.describe "match_team_members/new", :type => :view do
  before(:each) do
    assign(:match_team_member, MatchTeamMember.new(
      :match_team => nil,
      :team_member => nil
    ))
  end

  it "renders new match_team_member form" do
    render

    assert_select "form[action=?][method=?]", match_team_members_path, "post" do

      assert_select "input#match_team_member_match_team_id[name=?]", "match_team_member[match_team_id]"

      assert_select "input#match_team_member_team_member_id[name=?]", "match_team_member[team_member_id]"
    end
  end
end
