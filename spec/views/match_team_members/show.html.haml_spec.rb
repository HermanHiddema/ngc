require 'rails_helper'

RSpec.describe "match_team_members/show", :type => :view do
  before(:each) do
    @match_team_member = assign(:match_team_member, MatchTeamMember.create!(
      :match_team => nil,
      :team_member => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
