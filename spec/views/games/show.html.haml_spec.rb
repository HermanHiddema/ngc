require 'rails_helper'

RSpec.describe "games/show", :type => :view do
  before(:each) do
    @game = assign(:game, Game.create!(
      :match => nil,
      :black => nil,
      :white => nil,
      :black_points => "Black Points",
      :white_points => "White Points",
      :reason => "Reason"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Black Points/)
    expect(rendered).to match(/White Points/)
    expect(rendered).to match(/Reason/)
  end
end
