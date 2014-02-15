class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def i18n
    if session[:lang] == 'eng'
      @home = 'Home'
      @hours = 'Business Hours'
      @updates = 'Updates'
      @create_own = 'Text 000-000-0000 to create your own page!'
      @slogan = 'Putting small businesses online'
      @search = 'search'
      @filter = 'Filter by category:'

      # Categories
      @restaurant = 'restaurant'
      @pharmacy = 'pharmacy'
      @electronics = 'electronics'
      @culture = 'culture'
      @shopping = 'shopping'
      @govt = 'government'
      @education = 'education'
      @business = 'business'
      @traditional = 'traditional'
    else
      @home = 'Home'
      @hours = 'Business Hours'
      @updates = 'Updates'
      @create_own = 'Text 000-000-0000 to create your own page!'
      @slogan = 'Putting small businesses online'
      @search = 'search'
      @filter = 'Filter by category:'

      # Categories
      @restaurant = 'restaurant'
      @pharmacy = 'pharmacy'
      @electronics = 'electronics'
      @culture = 'ثقافة'
      @shopping = 'تسوّق'
      @govt = 'حكومة'
      @education = 'تعليم'
      @business = 'تجارة'
      @traditional = 'تقليدي'
    end

    @categories = [@food, @pharmacy, @electronics, @culture, @shopping,
                   @education, @govt, @business, @traditional]
  end
end
