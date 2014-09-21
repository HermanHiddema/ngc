require 'rails_helper'

RSpec.describe "venues/show", :type => :view do
  before(:each) do
    @venue = assign(:venue, Venue.create!(
      :club => nil,
      :name => "Name",
      :playing_day => "Playing Day",
      :playing_time => "Playing Time",
      :info => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Playing Day/)
    expect(rendered).to match(/Playing Time/)
    expect(rendered).to match(/MyText/)
  end
end
