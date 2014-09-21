require 'rails_helper'

RSpec.describe "team_members/index", :type => :view do
  before(:each) do
    assign(:team_members, [
      TeamMember.create!(
        :lastname => "Lastname",
        :firstname => "Firstname",
        :rating => 1,
        :club => nil,
        :team => nil
      ),
      TeamMember.create!(
        :lastname => "Lastname",
        :firstname => "Firstname",
        :rating => 1,
        :club => nil,
        :team => nil
      )
    ])
  end

  it "renders a list of team_members" do
    render
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
