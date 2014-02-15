class PagesController < ApplicationController

  def catchall
    if is_home?(request.host)
      @page_showing = 'showing-home'
      @categories = ['food', 'pharmacy', 'electronics']
      @pages = Store.all
      render :template => 'pages/home'
    else
      @page_showing = 'showing-page'
      page_name = request.host.split('.')[0]
      @store = Store.where(subdomain: page_name).first
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
