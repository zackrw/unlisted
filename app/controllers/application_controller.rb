class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def i18n
    #if session[:lang] == 'eng'
    @home = 'Home'
    @hours = 'Business Hours'
    @updates = 'Updates'
    @create_own = 'Text 000-000-0000 to create your own page!'
    @slogan = 'Putting small businesses online'
    @search = 'search'
    @filter = 'Filter by category:'

    # Categories
    @food = 'food'
    @pharmacy = 'pharmacy'
    @electronics = 'electronics'
    #end
  end
end
