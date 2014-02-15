class PagesController < ApplicationController

  def catchall
    if is_home?(request.host)
      @page_showing = 'showing-home'
      store = {
        phone: '+71 971 340-3492',
        name: 'Jake\'s Kitchen',
        subdomain: 'jakeskitchen',
        slogan: 'The best food ever',
        status: 'Jake\'s is currently featuring a two for
                 one special on margaritas.',
        location: '26 Institute Way',
        city: 'Abu Dhabi',
        country: 'UAE',
        category: 'food',
        hours: [
          { title: 'M-F', value: '8am - 9pm' },
          { title: 'Sa', value: '10am - 7pm' },
          { title: 'Su', value: '11am - 5pm' }
        ]
      }
      @categories = ['food', 'pharmacy', 'electronics']
      @pages = [store, store, store, store, store, store, store]
      render :template => 'pages/home'
    else
      @page_showing = 'showing-page'
      page_name = request.host.split('.')[0]
      @store = Store.where(subdomain: page_name).load()
      @category = @store.category.name
      render :template => 'pages/view'
    end
  end

  def is_home?(host)
    host_parts = request.host.split('.')
    threshold = 2
    if host_parts.include?('localhost')
      threshold = 1
    end
    host_parts.length <= threshold
  end

  def gohome
    host_parts = request.host.split('.')
    if host_parts.include?('localhost')
      redirect_to('http://localhost:3000')
    else
      redirect_to('http://unlisted.herokuapp.com')
    end
  end

  def goview
    host_parts = request.host.split('.')
    subdomain = params[:subdomain]
    if host_parts.include?('localhost')
      redirect_to("http://#{subdomain}.localhost:3000")
    else
      redirect_to("http://#{subdomain}.unlisted.herokuapp.com")
    end
  end

end
