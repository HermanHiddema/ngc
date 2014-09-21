require 'rails_helper'

RSpec.describe "people/new", :type => :view do
  before(:each) do
    assign(:person, Person.new(
      :firstname => "MyString",
      :lastname => "MyString",
      :egd_pin => "MyString",
      :email => "MyString"
    ))
  end

  it "renders new person form" do
    render

    assert_select "form[action=?][method=?]", people_path, "post" do

      assert_select "input#person_firstname[name=?]", "person[firstname]"

      assert_select "input#person_lastname[name=?]", "person[lastname]"

      assert_select "input#person_egd_pin[name=?]", "person[egd_pin]"

      assert_select "input#person_email[name=?]", "person[email]"
    end
  end
end
