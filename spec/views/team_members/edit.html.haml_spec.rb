require 'rails_helper'

RSpec.describe "team_members/edit", :type => :view do
  before(:each) do
    @team_member = assign(:team_member, TeamMember.create!(
      :lastname => "MyString",
      :firstname => "MyString",
      :rating => 1,
      :club => nil,
      :team => nil
    ))
  end

  it "renders the edit team_member form" do
    render

    assert_select "form[action=?][method=?]", team_member_path(@team_member), "post" do

      assert_select "input#team_member_lastname[name=?]", "team_member[lastname]"

      assert_select "input#team_member_firstname[name=?]", "team_member[firstname]"

      assert_select "input#team_member_rating[name=?]", "team_member[rating]"

      assert_select "input#team_member_club_id[name=?]", "team_member[club_id]"

      assert_select "input#team_member_team_id[name=?]", "team_member[team_id]"
    end
  end
end
