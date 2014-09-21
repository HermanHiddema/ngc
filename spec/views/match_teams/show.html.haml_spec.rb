require 'rails_helper'

RSpec.describe "match_teams/show", :type => :view do
  before(:each) do
    @match_team = assign(:match_team, MatchTeam.create!(
      :match => nil,
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
