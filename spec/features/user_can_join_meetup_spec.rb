require 'spec_helper'

feature "User clicks Join Meetup" do
  let(:user) do
    User.create(
      id: 1,
      provider: "github",
      uid: "1",
      username: "jose",
      email: "jose@jose.com",
      avatar_url: "www.jose.com"
    )
  end

  before(:each) do
    Meetup.create(
      name: "Space Meetup",
      description: "This is a meetup to talk about space",
      location: "My house",
      creator: "1"
    )
  end

  scenario "is not logged in" do
    visit '/' 
    sign_in_as user

    click_link "Sign Out"

    click_link('Space Meetup')
    click_button('Join Meetup')

    expect(page).to have_content "You need to be login to join a meetup!"
  end

  scenario "is logged in" do
    visit '/' 
    sign_in_as user


    click_link('Space Meetup')
    click_button('Join Meetup')

    expect(page).to have_content "You signed up for the Space Meetup"

    expect(page).to have_content "jose"
  end

  scenario "tries to Join Meetup more than once" do
    visit '/' 
    sign_in_as user


    click_link('Space Meetup')
    click_button('Join Meetup')
    click_button('Join Meetup')

    expect(page).to have_content "You already joined this meetup"
  end
end
