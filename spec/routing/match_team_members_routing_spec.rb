require "rails_helper"

RSpec.describe MatchTeamMembersController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/match_team_members").to route_to("match_team_members#index")
    end

    it "routes to #new" do
      expect(:get => "/match_team_members/new").to route_to("match_team_members#new")
    end

    it "routes to #show" do
      expect(:get => "/match_team_members/1").to route_to("match_team_members#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/match_team_members/1/edit").to route_to("match_team_members#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/match_team_members").to route_to("match_team_members#create")
    end

    it "routes to #update" do
      expect(:put => "/match_team_members/1").to route_to("match_team_members#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/match_team_members/1").to route_to("match_team_members#destroy", :id => "1")
    end

  end
end
