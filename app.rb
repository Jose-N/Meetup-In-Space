require 'pry'
require 'sinatra'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @all_meetups = Meetup.order(:name)
  erb :'meetups/index'
end

get '/meetups/new' do
  erb :'meetups/create'
end

post '/meetups/new' do
  @name_error = ''
  @description_error = ''
  @location_error = ''
  @creator_error = ''
  @name = params['name']
  @description = params['description']
  @location = params['location']
  creator = session['user_id']

  if @name.strip() != '' && @description.strip() != '' && @location.strip() != '' && !creator.nil? 
    Meetup.create(
      name: @name,
      description: @description,
      location: @location,
      creator: creator
    )

    redirect '/meetups'
  else
    if @name.strip() == ''
      @name_error = 'Meetup Must Have A Name'
    end

    if @description.strip() == ''
      @description_error = 'Meetup Must Have A Description'
    end

    if @location.strip() == ''
      @location_error = 'Meetup Must Have A Location'
    end

    if creator.nil? 
      @creator_error = 'You Must Be Signed In'
    end

    erb :'/meetups/create'
  end
end

post '/meetups/:id' do
  @user_id = params['user_id']
  @meetup_id = params['meetup_id']

  if @user_id.strip() != '' && @meetup_id.strip() != '' && !Meetup.find(@meetup_id).users.exists?(@user_id)
    Rsvp.create(
      user_id: @user_id,
      meetup_id: @meetup_id
    )

    flash[:notice] = "You signed up for the #{Meetup.find(@meetup_id)['name']}"

    redirect "/meetups/#{@meetup_id}"
  else 
    if @user_id.strip() == ''
      flash[:notice] = 'You need to be login to join a meetup!'
    end

    if @meetup_id.strip() == ''
      flash[:notice] = 'How did you even do this'
    end

    if Meetup.find(@meetup_id).users.exists?(@user_id)
      flash[:notice] = 'You already joined this meetup'
    end

    redirect "/meetups/#{@meetup_id}"
  end
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @creator_name = User.find(@meetup['creator'])['username']
  @user_id = session['user_id']
  @meetup_id = params[:id]
  @going = Meetup.find(@meetup_id).users
  if session['user_id'].to_i == @meetup['creator'] 
    @hi = 'hi'
  end

  erb :'meetups/show'
end
