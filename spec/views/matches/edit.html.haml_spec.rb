require 'rails_helper'

RSpec.describe "matches/edit", :type => :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      :league => nil
    ))
  end

  it "renders the edit match form" do
    render

    assert_select "form[action=?][method=?]", match_path(@match), "post" do

      assert_select "input#match_league_id[name=?]", "match[league_id]"
    end
  end
end
