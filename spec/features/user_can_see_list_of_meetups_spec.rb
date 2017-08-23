require 'spec_helper'

feature "User can see list of meetups on homepage" do
  before(:each) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jose",
      email: "jose@jose.com",
      avatar_url: "www.jose.com"
    )

    Meetup.create(
      name: "Space Meetup",
      description: "This is a meetup to talk about space",
      location: "My house",
      creator: "1"
    )
  end

  scenario "user goes to main page" do
    visit '/'

    expect(page).to have_content "Space Meetup"
  end
end
