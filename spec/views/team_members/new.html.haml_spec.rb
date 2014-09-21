require 'rails_helper'

RSpec.describe "team_members/new", :type => :view do
  before(:each) do
    assign(:team_member, TeamMember.new(
      :lastname => "MyString",
      :firstname => "MyString",
      :rating => 1,
      :club => nil,
      :team => nil
    ))
  end

  it "renders new team_member form" do
    render

    assert_select "form[action=?][method=?]", team_members_path, "post" do

      assert_select "input#team_member_lastname[name=?]", "team_member[lastname]"

      assert_select "input#team_member_firstname[name=?]", "team_member[firstname]"

      assert_select "input#team_member_rating[name=?]", "team_member[rating]"

      assert_select "input#team_member_club_id[name=?]", "team_member[club_id]"

      assert_select "input#team_member_team_id[name=?]", "team_member[team_id]"
    end
  end
end
