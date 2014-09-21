require 'rails_helper'

RSpec.describe "participants/show", :type => :view do
  before(:each) do
    @participant = assign(:participant, Participant.create!(
      :firstname => "Firstname",
      :lastname => "Lastname",
      :rating => 1,
      :egd_pin => "Egd Pin",
      :club => nil,
      :season => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/Egd Pin/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
