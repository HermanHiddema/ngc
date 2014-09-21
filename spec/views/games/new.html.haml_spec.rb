require 'rails_helper'

RSpec.describe "games/new", :type => :view do
  before(:each) do
    assign(:game, Game.new(
      :match => nil,
      :black => nil,
      :white => nil,
      :black_points => "MyString",
      :white_points => "MyString",
      :reason => "MyString"
    ))
  end

  it "renders new game form" do
    render

    assert_select "form[action=?][method=?]", games_path, "post" do

      assert_select "input#game_match_id[name=?]", "game[match_id]"

      assert_select "input#game_black_id[name=?]", "game[black_id]"

      assert_select "input#game_white_id[name=?]", "game[white_id]"

      assert_select "input#game_black_points[name=?]", "game[black_points]"

      assert_select "input#game_white_points[name=?]", "game[white_points]"

      assert_select "input#game_reason[name=?]", "game[reason]"
    end
  end
end
