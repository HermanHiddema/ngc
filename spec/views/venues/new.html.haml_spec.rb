require 'rails_helper'

RSpec.describe "venues/new", :type => :view do
  before(:each) do
    assign(:venue, Venue.new(
      :club => nil,
      :name => "MyString",
      :playing_day => "MyString",
      :playing_time => "MyString",
      :info => "MyText"
    ))
  end

  it "renders new venue form" do
    render

    assert_select "form[action=?][method=?]", venues_path, "post" do

      assert_select "input#venue_club_id[name=?]", "venue[club_id]"

      assert_select "input#venue_name[name=?]", "venue[name]"

      assert_select "input#venue_playing_day[name=?]", "venue[playing_day]"

      assert_select "input#venue_playing_time[name=?]", "venue[playing_time]"

      assert_select "textarea#venue_info[name=?]", "venue[info]"
    end
  end
end
