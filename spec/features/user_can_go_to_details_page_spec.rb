require 'spec_helper'

feature "User can see go to details page of meetup" do
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

  scenario "user goes to show page of a meetup" do
    visit '/'
    sign_in_as user

    click_link('Space Meetup')

    expect(page).to have_content "Space Meetup"
    expect(page).to have_content "This is a meetup to talk about space"
    expect(page).to have_content "My house"
    expect(page).to have_content "jose"
  end
end
