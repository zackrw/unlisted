class SendsmsController < ApplicationController
  def index
  end

  def send_sms_message
    number_to_send_to = params[:number_to_send_to]

    twilio_sid = ENV['TWILIO_SID']
    twilio_token = ENV['TWILIO_TOKEN']
    twilio_phone_number = '7732451971'

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token
    @twilio_client.account.sms.messages.create(
      :from => "+1#{twilio_phone_number}",
      :to => number_to_send_to,
      :body => "Goodbye World! This is an message. It gets sent to #{number_to_send_to}"
    )
    render text: 'Success!'
  end
end
