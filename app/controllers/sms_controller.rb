class SmsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  @@fields = ["name","subdomain","city","location","neighborhood","slogan","category","hours"]
  @@days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

  def index
    redirect_to(:action => :receive, :phone => params[:phone]);
  end

  def receive
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
    elsif not store.next or store.next >= @@fields.length
      #All fields have been filled, message is a status update
      if response
        store.update(:status => response)
        return "Status updated to: " + store.status
      else
        return nil
      end
    else
      validatedResponse = validate(store.next, response)
      if not validatedResponse[:valid]
        return validatedResponse[:error] + " " + generateReply(store.next)
      else
        if @@fields[store.next] == "neighborhood"
          Geocoder.configure(:lookup   => :yandex)
          geoResult = Geocoder.search(response + ", " + store.city + ", " + store.country)
          if geoResult.length > 0
            store.latitude = geoResult[0].latitude
            store.longitude = geoResult[0].longitude
          end
        end
        store.update({@@fields[store.next] => validatedResponse[:value], "next" => store.next+1})
      end
    end
    if store.next == @@fields.length
      #Setup complete!
      store.on_profile_complete
      return "Congratulations you've created a website! Send text messages to update your business status"
    else
      return generateReply(store.next)
    end
  end
  
  def validate(fieldId,response)
    field = @@fields[fieldId] 
    #Response is category id
    if field  == "category"
      return validateCategory(response)
    elsif field == "hours"
      return validateHours(response)
    elsif field == "name" or field == "subdomain"
      if not response or response.length == 0
        return {:valid => false, :error => "Response cannot be empty."}
      end
    end
    return {:valid => true, :value => response};
  end
  
  def generateReply(fieldId)
    field = @@fields[fieldId]
    if field == "category"
      categories = Category.find(:all)
      response = "Choose a business category number"
      categories.each do |cat|
      response << ", " << cat.name << "(" << cat.id.to_s << ")"
      end
    elsif field == "subdomain"
      response = "Choose a subdomain for your website: (<subdomain>.jed.ae)"
    elsif field == "hours"
      response = "Please enter your hours as day-range:hour-range (Mo-Th:0900-2100, Fr-Su:1000-1300):"
    else
      response = "Please enter your business " + field
    end
    return response
  end

  def validateCategory(response)
    category = Category.find_by_id(response.to_i)
      if category
        return {:valid => true, :value => category}
      else 
        return {:valid => false, :error => "Category ID is not valid."}
      end
  end

  def validateHours(response)
    hoursJSON = []
    #Iterate over day ranges
    if response.length() > 0
      response.split(',').each do |entry|
        if not entry.split(':').length == 2 
          return {:valid => false, :error => "Invalid day or hour range."}
        end
        #Get day range and hours value
        value = entry.split(':')[1]
        dayrange = entry.split(':')[0]
        if not dayrange.split('-').length == 2 
          return {:valid => false, :error => "Invalid day range."}
        end
        #Get start and end day indices
        startDay = @@days.index {|day| day.downcase.starts_with?(dayrange.split('-')[0].downcase)}
        endDay = @@days.index {|day| day.downcase.starts_with?(dayrange.split('-')[1].downcase)}
        if not startDay or not endDay
          return {:valid => false, :error => "Invalid day value(s)."}
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
