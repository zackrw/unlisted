class SmsController < ApplicationController

skip_before_filter :verify_authenticity_token

@@fields = ["name","city","location","slogan"]

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

    twilio_sid = ENV['TWILIO_SID']
    twilio_token = ENV['TWILIO_TOKEN']
    twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']

    twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token

    twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => phone,
      :body => response
    )
    render :nothing => true
  end

  def processResponse(phone,response)
    store = Store.find_by_phone(phone)
    if not store
      store = Store.new({:phone =>  phone, :next => 0});
      response = "Welcome to Jed! Please enter your business " + @@fields[store.next]
    elsif store.next == @@fields.length-1
      if response
        store.status = response
      end
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