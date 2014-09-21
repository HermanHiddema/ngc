require "rails_helper"

RSpec.describe MatchTeamsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/match_teams").to route_to("match_teams#index")
    end

    it "routes to #new" do
      expect(:get => "/match_teams/new").to route_to("match_teams#new")
    end

    it "routes to #show" do
      expect(:get => "/match_teams/1").to route_to("match_teams#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/match_teams/1/edit").to route_to("match_teams#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/match_teams").to route_to("match_teams#create")
    end

    it "routes to #update" do
      expect(:put => "/match_teams/1").to route_to("match_teams#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/match_teams/1").to route_to("match_teams#destroy", :id => "1")
    end

  end
end
