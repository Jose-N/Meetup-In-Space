require 'spec_helper'

feature "User can add a meetup" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end


  scenario "user can see creation form" do
    visit '/meetups/new'
    
    expect(page).to have_content "Name"
    expect(page).to have_content "Location"
    expect(page).to have_content "Description"
  end

  scenario "user can not create meetup if not signed in" do
    visit '/meetups/new'
    
    fill_in('name', :with => 'Rick')
    fill_in('location', :with => 'A House')
    fill_in('description', :with => 'heyhey')

    click_button('SUBMIT')

    expect(page).to have_content "You Must Be Signed In"
  end

  scenario "user can not create meetup if there is no name" do
    visit '/'
    sign_in_as user

    visit '/meetups/new'
    
    fill_in('location', :with => 'A House')
    fill_in('description', :with => 'heyhey')

    click_button('SUBMIT')

    expect(page).to have_content "Meetup Must Have A Name"
  end

  scenario "user can not create meetup if there is no location" do
    visit '/'
    sign_in_as user

    visit '/meetups/new'
    
    fill_in('name', :with => 'Rick')
    fill_in('description', :with => 'heyhey')

    click_button('SUBMIT')

    expect(page).to have_content "Meetup Must Have A Location"
  end

  scenario "user can not create meetup if there is no description" do
    visit '/'
    sign_in_as user

    visit '/meetups/new'
    
    fill_in('name', :with => 'Rick')
    fill_in('location', :with => 'A House')

    click_button('SUBMIT')

    expect(page).to have_content "Meetup Must Have A Description"
  end

  scenario "user can create a meetup" do
    visit '/'
    sign_in_as user

    visit '/meetups/new'
    
    fill_in('name', :with => 'Rick')
    fill_in('location', :with => 'A House')
    fill_in('description', :with => 'heyhey')

    click_button('SUBMIT')

    expect(page).to have_content "Rick"
  end
end
