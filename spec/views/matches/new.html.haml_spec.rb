require 'rails_helper'

RSpec.describe "matches/new", :type => :view do
  before(:each) do
    assign(:match, Match.new(
      :league => nil
    ))
  end

  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "input#match_league_id[name=?]", "match[league_id]"
    end
  end
end
