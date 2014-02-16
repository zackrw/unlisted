class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def i18n 
    if session[:lang] == 'english'
      @home = 'Home'
      @hours = 'Business Hours'
      @updates = 'Updates'
      @address = 'Address'
      @create_own = 'to create your own page!'
      @create_own2 = 'Text'
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
      
      @other_language = 'عربي'
      @phone_number = '+1-773-245-1971'
    else
      @home = 'الرئيسية'
      @hours = 'اوقات العمل'
      @updates = 'تحديث'
      @address = 'العنوان'
      @create_own = 'لانشاء صفحتك الخاصة'
      @create_own2 = 'ابعث ارسالية على'
      @slogan = ' وضع المؤسسات الصغرى على الانترنيت'
      @search = 'بحث'
      @filter = 'بحث حسب الفئة'

      # Categories
      @restaurant = 'مطعم'
      @pharmacy = 'صيدلية'
      @electronics = 'إلكترونيات'
      @culture = 'ثقافة'
      @shopping = 'تسوّق'
      @govt = 'حكومة'
      @education = 'تعليم'
      @business = 'تجارة'
      @traditional = 'تقليدي'

      @other_language = 'English'
      @phone_number = '1971-245-773-1+'
    end

    @categories = [@restaurant, @pharmacy, @electronics, @culture, @shopping,
                   @education, @govt, @business, @traditional]
  end
end
