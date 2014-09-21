require 'rails_helper'

RSpec.describe "leagues/edit", :type => :view do
  before(:each) do
    @league = assign(:league, League.create!(
      :name => "MyString",
      :order => 1,
      :season => nil
    ))
  end

  it "renders the edit league form" do
    render

    assert_select "form[action=?][method=?]", league_path(@league), "post" do

      assert_select "input#league_name[name=?]", "league[name]"

      assert_select "input#league_order[name=?]", "league[order]"

      assert_select "input#league_season_id[name=?]", "league[season_id]"
    end
  end
end
