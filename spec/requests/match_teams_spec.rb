require 'rails_helper'

RSpec.describe "MatchTeams", :type => :request do
  describe "GET /match_teams" do
    it "works! (now write some real specs)" do
      get match_teams_path
      expect(response).to have_http_status(200)
    end
  end
end
