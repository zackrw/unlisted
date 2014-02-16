class Store < ActiveRecord::Base
  #attr_accessible :phone, :name, :slogan, :status, :location, :city, :country, :latitude, :longitude, :hours, :subdomain

  belongs_to :category
  has_and_belongs_to_many :tags

  def on_profile_complete
    puts '-----------------------------------'
    puts 'PROFILE COMPLETE'
    puts '-----------------------------------'
    begin
      welcome_on_twitter
      welcome_on_facebook
    rescue
    end
  end

  def welcome_on_twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TWITTER_CONSUMER_KEY
      config.consumer_secret     = TWITTER_CONSUMER_SECRET
      config.access_token        = TWITTER_ACCESS_TOKEN
      config.access_token_secret = TWITTER_ACCESS_TOKEN_SECRET
    end
     client.update("Welcome to Jed, #{name} from #{city}, #{country}! " +
                   "Check them out at http://#{subdomain}.jedapp.com")
  end

  def welcome_on_facebook
    page = FbGraph::Page.new(654840051241163)
    link = page.link!(
      :access_token => FACEBOOK_ACCESS_TOKEN,
      :link => "http://#{subdomain}.jedapp.com",
      :message => "Congratulations #{name} from #{city}, " +
                  "#{country}! Welcome to Jed, the simplest " +
                  "way to get your small business online. " +
                  "Check them out at http://#{subdomain}.jedapp.com")
  end

end
