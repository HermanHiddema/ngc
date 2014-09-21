require 'rails_helper'

RSpec.describe "MatchTeamMembers", :type => :request do
  describe "GET /match_team_members" do
    it "works! (now write some real specs)" do
      get match_team_members_path
      expect(response).to have_http_status(200)
    end
  end
end
