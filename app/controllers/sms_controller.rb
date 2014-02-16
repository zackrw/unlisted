# -*- coding: utf-8 -*-
class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  @@intro = "رحبا بكم في 'جِد' اضغط  1 للعربية Welcome to Jed! Choose 2 for english"

  #Fields and prompts
  @@fields = Array.new(2){Array.new}
  @@days = Array.new(2){Array.new}
  @@category =Array.new(2){Array.new} 
  @@hours =Array.new(2){Array.new} 
  @@prompt = Array.new(2){Array.new}
  @@invalid =Array.new(2){Array.new} 
  @@congrats = Array.new(2){Array.new}
  @@status =Array.new(2){Array.new} 

  @@fields[0] = ["language","name","category","city","location","neighborhood","hours","slogan"]
  @@days[0] = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
  @@category[0] = "Choose a category number for your business"
  @@hours[0] = "Please enter your business hours as day-range:hour-range (Mo-Th:0900-2100, Fr-Su:1000-1300):"
  @@prompt[0] = "Please enter your business "
  @@invalid[0] = "Invalid entry for "
  @@congrats[0] = "Congratulations you've created a website, $XX_URL_XX$! Send text messages to update your business status"
  @@status[0] = "Status updated to "

  #arabic translations
  @@days[1] = ["الاثنين","الثلاثاء","الاربعاء","الخميس","الجمعة","السبت","الاحد"]
  @@fields[1] = ["الاسم","المدينة","الفئة","العنوان","الجوار","اوقات العمل","الشعار"]
  @@category[1] = "اختر رقم الفئة المناسب لمؤسستك "
  @@hours[1] = "من فضلك ادخل ايام و اوقات العمل "
  @@prompt[1] = "من فضلك ادخل "
  @@invalid[1] = "إدخال غير صالح "
  @@congrats[1] = "تهانينا لقد انشئت موقعك الخاص !$XX_URL_XX$ ,ابعث ارساليات لتحديث محتوى موقعك "
  @@status[1] =  "تحديث  محتوى موقعك "

  def index
    puts 'INDEX CALLED'
    puts params
    redirect_to(:action => :receive, :phone => params[:phone]);
  end

  def receive
    puts params
    puts "----------------------------------"
    puts "RECEIVING TEXT!"
    puts "----------------------------------"
    phone = params["From"]
    message = params["Body"]
    response = processResponse(phone, message)

    twilio_phone_number = TWILIO_PHONE_NUMBER

    twilio_client = Twilio::REST::Client.new(TWILIO_SID, TWILIO_TOKEN)

    twilio_client.account.sms.messages.create(
      :from => TWILIO_PHONE_NUMBER,
      :to => phone,
      :body => response
    )
    render :nothing => true
  end

  #Takes in a phone number and a text message, returns the response to send back
  def processResponse(phone, response)
    store = Store.find_by_phone(phone)
    if not store
      #Create a new store
      store = Store.new({:phone =>  phone, :next => 0, :country => "UAE"});
      store.save
      return @@intro
    elsif not store.next or store.next >= @@fields[0].length
      #All fields have been filled, message is a status update
      if response
        store.update(:status => response)
        return @@status[store.language] + store.status
      else
        return nil
      end
    else
      #Message is a field update
      validatedResponse = validate(store, response)
      if not validatedResponse[:valid]
        return @@invalid[store.language] + @@fields[store.language][store.next] + " " + generateReply(store)
      else
        store.update({@@fields[0][store.next] => validatedResponse[:value], "next" => store.next+1})
      end
    end
    #Prepare response message to user
    if store.next == @@fields[0].length
      #Setup complete!
      store.on_profile_complete
      return @@congrats[store.language].gsub('$XX_URL_XX$',
                                       " http://#{store.subdomain}.jedapp.com ")
    else
      return generateReply(store)
    end
  end
  
  #Validate the message and process the response if needed
  def validate(store,response)
    field = @@fields[0][store.next]
    #Response is category id
    if field  == "category"
      return validateCategory(response)
    elsif field == "hours"
      return validateHours(response,store)
    elsif field == "name"
      if not response or response.length == 0
        return {:valid => false}
      else
        store.update({:subdomain => response.downcase.gsub(/[^\w]/,'')})
      end
    elsif field == "neighborhood"
      Geocoder.configure(:lookup   => :yandex)
      geoResult = Geocoder.search(response + ", " + store.city + ", " + store.country)
      if geoResult.length > 0
        store.update({:latitude => geoResult[0].latitude, :longitude => geoResult[0].longitude})
      end
    elsif field == "language"
      if response.to_i == 2
        response = 0
      elsif response.to_i == 1
        response = 1
      else
        return {:valid => false}
      end
    end    
    return {:valid => true, :value => response};
  end
  
  #Generate the response for the user
  def generateReply(store)
    field = @@fields[0][store.next]
    languageId = store.language
    if field == "category"
      categories = Category.find(:all)
      response = @@category[languageId]
      categories.each do |cat|
        if languageId == 0
          response << ", " << cat.name << "(" << cat.id.to_s << ")"
        elsif languageId == 1
          response << ", " << cat.arabic_name << "(" << cat.id.to_s << ")"
        end
      end
    elsif field == "hours"
      response = @@hours[languageId]
    elsif field == "language"
      response == @@intro[languageId]
    elsif field == "location" and languageId == 0
      response == @@prompt[languageId] + "address"
    else
      response = @@prompt[languageId] + @@fields[languageId][store.next]
    end
    return response
  end

  def validateCategory(response)
    category = Category.find_by_id(response.to_i)
      if category
        return {:valid => true, :value => category}
      else
        return {:valid => false}
      end
  end

  def validateHours(response, store)
    languageId = store.language
    hoursJSON = []
    #Iterate over day ranges
    if response.length() > 0
      response.split(',').each do |entry|
        if not entry.split(':').length == 2 
          return {:valid => false}
        end
        #Get day range and hours value
        value = entry.split(':')[1]
        dayrange = entry.split(':')[0]
        if not dayrange.split('-').length == 2 
          return {:valid => false}
        end
        #Get start and end day indices
        startDay = @@days[languageId].index {|day| day.downcase.starts_with?(dayrange.split('-')[0].downcase)}
        endDay = @@days[languageId].index {|day| day.downcase.starts_with?(dayrange.split('-')[1].downcase)}
        if not startDay or not endDay
          return {:valid => false}
        end
        #Add to hours json array
        (startDay..endDay).each do |i|
          hoursJSON << {"title" => i, "value" => value}
        end
      end
    end
    return {:valid => true, :value => hoursJSON}
  end
end
