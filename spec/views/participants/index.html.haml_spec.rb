require 'rails_helper'

RSpec.describe "participants/index", :type => :view do
  before(:each) do
    assign(:participants, [
      Participant.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :rating => 1,
        :egd_pin => "Egd Pin",
        :club => nil,
        :season => nil
      ),
      Participant.create!(
        :firstname => "Firstname",
        :lastname => "Lastname",
        :rating => 1,
        :egd_pin => "Egd Pin",
        :club => nil,
        :season => nil
      )
    ])
  end

  it "renders a list of participants" do
    render
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Egd Pin".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
