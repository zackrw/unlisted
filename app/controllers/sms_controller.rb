class SmsController < ApplicationController
@@fields = ["name","subdomain","city","location","slogan","category","hours"]
@@days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]

def index
  redirect_to(:action => :receive, :phone => '+24 456 456 456')
end

def receive
  #Process POST from phone
  message = processResponse(params[:phone],params[:response])

  #POST to phone
  @form_params = {:phone => params[:phone], :message => message};
  render(:action => :index)  

end  

#Takes in a phone number and a text message, returns the response to send back
def processResponse(phone,response)
  store = Store.find_by_phone(phone)
  if not store
    #Create a new store
    store = Store.new({:phone =>  '+24 456 456 456', :next => 0});
    store.save
    return "Welcome to Jed! Please enter your business " + @@fields[store.next]
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
      store.update({@@fields[store.next] => validatedResponse[:value], "next" => store.next+1})
    end
  end
  if store.next == @@fields.length
    #Setup complete!
    return "Congratulations you've created a website! Send text messages to update your business status"
  else
    return generateReply(store.next)
  end
end

def validate(fieldId,response)
  field = @@fields[fieldId] 
  #Response is category id
  if field  == "category"
    category = Category.find_by_id(response.to_i)
    if category
      response = category
    else 
      return {:valid => false, :error => "Category ID is not valid."}
    end
  elsif field == "hours"
    hoursJSON = []
    #Iterate over day ranges
    response.split(',').each do |entry|
      if not entry.split(':').length == 2 
        return {:valid => false, :error => "Day and hour ranges must be split with : ."}
      end
      #Get day range and hours value
      value = entry.split(':')[1]
      dayrange = entry.split(':')[0]
      if not dayrange.split('-').length == 2 
        return {:valid => false, :error => "Day range must be split with - ."}
      end
      #Get start and end day indices
      startDay = @@days.index {|day| day.downcase.starts_with?(dayrange.split('-')[0].downcase)}
      endDay = @@days.index {|day| day.downcase.starts_with?(dayrange.split('-')[1].downcase)}
      if not startDay or not endDay
        return {:valid => false, :error => "Day value(s) not valid."}
      end
      #Add to hours json array
      (startDay..endDay).each do |i|
        hoursJSON << {"title" => i, "value" => value}
      end
    end
    response = hoursJSON
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
    response = "Please enter your hours as day-range : hour-range (Mo-Th : 0900-2100, Fr-Su : 1000-1300):"
  else
    response = "Please enter your business " + field
  end
  return response
end

end
