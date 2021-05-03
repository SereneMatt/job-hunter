class SessionsController < ApplicationController
  def new
    if session[:user_id]
      redirect_to jobs_path
    end
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    unless user
      user = User.create(username: params[:session][:username].downcase)
    end

    # Keep user signed in for the current session
    session[:user_id] = user.id

    redirect_to jobs_path
  end
end
