module ApplicationHelper
  def current_user
    # Memoize to avoid hitting database for every time a user session is checked
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end
end
