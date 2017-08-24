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

    redirect "/meetups/#{Meetup.last.id}"
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

post '/meetups/comment' do
  @body = params[:body]
  @meetup_id = params[:meetup_id]
  @user_id = params[:user_id]
  @attendee = Meetup.find(@meetup_id).users.exists?(@user_id)

  if @body.strip != '' && @user_id != '' && @meetup != '' && @attendee
    Comment.create(
      meetup_id: @meetup_id.to_i,
      user_id: @user_id.to_i,
      body: @body
    )
  else
    if !@attendee
      flash[:notice] = "Must Join Meetup To Leave Comment"
      query = params.map{|key, value| "#{key}=#{value}"}.join("&")
      redirect to("/meetups/#{@meetup_id.to_i}?#{query}")
    end
  end
  redirect "/meetups/#{@meetup_id.to_i}"
end

get '/meetups/update/:id' do
  @meetup = Meetup.find(params[:id])
  @name = @meetup['name']
  @location = @meetup['location']
  @description = @meetup['description']

  if session['user_id'].to_i != @meetup['creator'].to_i 
    flash[:notice] = "You Can Not Edit A Meetup If You Did Not Create It"

    redirect '/'
  end

  erb :'meetups/update'
end

post '/meetups/update/:id' do
  id = params[:id]
  @meetup = Meetup.find(id)
  @name = params['name']
  @description = params['description']
  @location = params['location']


  if @name.strip() != '' && @description.strip() != '' && @location.strip() != ''
    Meetup.update(
      id,
      :name => @name,
      :location => @location,
      :description => @description
    )

    flash[:notice] = "Successully Edited Meetup"

    redirect "/meetups/#{id}"
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

    erb :'/meetups/update'
  end
end

get '/meetups/destroy/:id' do
  @meetup = Meetup.find(params[:id])
  if session['user_id'].to_i != @meetup['creator'].to_i 
    flash[:notice] = "You Do Not Have Permission To Delete This Meetup"

    redirect '/'
  else
    @meetup.destroy
    flash[:notice] = "Successully Deleted Meetup"
    redirect '/'
  end

end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @creator_name = User.find(@meetup['creator'])['username']
  @user_id = session['user_id']
  @meetup_id = params[:id]
  @going = Meetup.find(@meetup_id).users
  @logged_in =  !@user_id.nil?
  @comments = @meetup.comments

  if session['user_id'].to_i == @meetup['creator'].to_i 
    @owner = true 
  else
    if Meetup.find(@meetup_id).users.exists?(@user_id)
      @button = "Leave Meetup"
    else
      @button = "Join Meetup"
    end
  end

  erb :'meetups/show'
end

post '/meetups/:id' do
  @user_id = params['user_id']
  @meetup_id = params['meetup_id']

  if @user_id.strip() != '' && @meetup_id.strip() != '' && !Meetup.find(@meetup_id).users.exists?(@user_id)
    Rsvp.create(
      user_id: @user_id,
      meetup_id: @meetup_id
    )

    redirect "/meetups/#{@meetup_id}"
  else 
    if @user_id.strip() == ''
      flash[:notice] = 'You need to be login to join a meetup!'
    end

    if @meetup_id.strip() == ''
      flash[:notice] = 'How did you even do this'
    end

    if Meetup.find(@meetup_id).users.exists?(@user_id)
      to_be_removed = Rsvp.where(["user_id = ? and meetup_id = ?", @user_id, @meetup_id])
      to_be_removed[0].destroy
    end

    redirect "/meetups/#{@meetup_id}"
  end
end
