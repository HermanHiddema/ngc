require 'rails_helper'

RSpec.describe "match_team_members/edit", :type => :view do
  before(:each) do
    @match_team_member = assign(:match_team_member, MatchTeamMember.create!(
      :match_team => nil,
      :team_member => nil
    ))
  end

  it "renders the edit match_team_member form" do
    render

    assert_select "form[action=?][method=?]", match_team_member_path(@match_team_member), "post" do

      assert_select "input#match_team_member_match_team_id[name=?]", "match_team_member[match_team_id]"

      assert_select "input#match_team_member_team_member_id[name=?]", "match_team_member[team_member_id]"
    end
  end
end
