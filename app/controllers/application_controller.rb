class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_chef, :logged_in?
  
  def current_chef #current chef that is logged in
    @current_chef ||= Chef.find(session[:chef_id]) if session[:chef_id] #graph current chef or find out the current chef and store it
    
  end
  
  def logged_in?
    !!current_chef  #!! turns any expression into a true-false statement
  end
  
  def require_user  #use to restrict actions if user is not logged in
    if !logged_in?
      flash[:danger] = "You must be logged in to perform that action"
      redirect_to root_path
    end
  end
  
end
