require 'rails_helper'

RSpec.describe "team_members/show", :type => :view do
  before(:each) do
    @team_member = assign(:team_member, TeamMember.create!(
      :lastname => "Lastname",
      :firstname => "Firstname",
      :rating => 1,
      :club => nil,
      :team => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
