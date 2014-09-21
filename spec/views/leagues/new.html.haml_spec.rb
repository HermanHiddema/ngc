require 'rails_helper'

RSpec.describe "leagues/new", :type => :view do
  before(:each) do
    assign(:league, League.new(
      :name => "MyString",
      :order => 1,
      :season => nil
    ))
  end

  it "renders new league form" do
    render

    assert_select "form[action=?][method=?]", leagues_path, "post" do

      assert_select "input#league_name[name=?]", "league[name]"

      assert_select "input#league_order[name=?]", "league[order]"

      assert_select "input#league_season_id[name=?]", "league[season_id]"
    end
  end
end
