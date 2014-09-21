require 'rails_helper'

RSpec.describe "people/show", :type => :view do
  before(:each) do
    @person = assign(:person, Person.create!(
      :firstname => "Firstname",
      :lastname => "Lastname",
      :egd_pin => "Egd Pin",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Firstname/)
    expect(rendered).to match(/Lastname/)
    expect(rendered).to match(/Egd Pin/)
    expect(rendered).to match(/Email/)
  end
end
