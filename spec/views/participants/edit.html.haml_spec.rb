require 'rails_helper'

RSpec.describe "participants/edit", :type => :view do
  before(:each) do
    @participant = assign(:participant, Participant.create!(
      :firstname => "MyString",
      :lastname => "MyString",
      :rating => 1,
      :egd_pin => "MyString",
      :club => nil,
      :season => nil
    ))
  end

  it "renders the edit participant form" do
    render

    assert_select "form[action=?][method=?]", participant_path(@participant), "post" do

      assert_select "input#participant_firstname[name=?]", "participant[firstname]"

      assert_select "input#participant_lastname[name=?]", "participant[lastname]"

      assert_select "input#participant_rating[name=?]", "participant[rating]"

      assert_select "input#participant_egd_pin[name=?]", "participant[egd_pin]"

      assert_select "input#participant_club_id[name=?]", "participant[club_id]"

      assert_select "input#participant_season_id[name=?]", "participant[season_id]"
    end
  end
end
