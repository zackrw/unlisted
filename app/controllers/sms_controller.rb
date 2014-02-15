class SmsController < ApplicationController
@@fields = ["name","city","location","slogan"]
  
def index
  redirect_to(:action => :receive, :phone => '+24 456 456 456');
end

def receive
  message = processResponse(params[:phone],params[:response])
  
  @form_params = {:phone => params[:phone], :message => message};
  render(:action => :index)  

end  

def processResponse(phone,response)
  store = Store.find_by_phone(phone)
  if not store
    store = Store.new({:phone =>  '+24 456 456 456', :next => 0});
    response = "Welcome to Jed! Please enter your business " + @@fields[store.next]
  elsif store.next == @@fields.length-1
    store.status = response
    response = "Status updated to " + store.status
  else
    store[@@fields[store.next]] = response
    store.next = store.next+1
    response =  "Please enter your business " + @@fields[store.next]
  end
  store.save
  return response
end

end
