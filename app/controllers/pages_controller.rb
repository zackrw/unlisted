class PagesController < ApplicationController

  def view
    @store = {
      phone: '+71 971 340-3492',
      name: 'Jake\'s Kitchen',
      slogan: 'The best food ever',
      status: 'Jake\'s is currently featuring a two for
               one special on margaritas.',
      location: '26 Institute Way',
      city: 'Abu Dhabi',
      country: 'UAE',
      hours: [
        { title: 'M-F', value: '8am - 9pm' },
        { title: 'Sa', value: '10am - 7pm' },
        { title: 'Su', value: '11am - 5pm' }
      ]
    }
    @category = 'food'
    @tags = 'yummy, tasty, delicious'
  end

  def home
  end

end
