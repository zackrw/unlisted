class PagesController < ApplicationController

  def catchall
    if is_home?(request.host)
      @page_showing = 'showing-home'
      @categories = []
      Category.all.each do |c|
        @categories.push(c.name)
      end
      @pages = Store.order(:name)
      render :template => 'pages/home'
    else
      @page_showing = 'showing-page'
      page_name = request.host.split('.')[0]
      @store = Store.where(subdomain: page_name).first
      @category = @store.category.name
      @domain = request.host.split('.')[1]
      render :template => 'pages/view'
    end
  end

  def is_home?(host)
    host_parts = request.host.split('.')
    ['localhost', 'www', 'jedappuae'].include?(host_parts[0])
  end

  def gohome
    host_parts = request.host.split('.')
    if host_parts.include?('localhost')
      redirect_to('http://localhost:3000')
    else
      redirect_to('http://jedappuae.herokuapp.com')
    end
  end

  def goview
    host_parts = request.host.split('.')
    subdomain = params[:subdomain]
    if host_parts.include?('localhost')
      redirect_to("http://#{subdomain}.localhost:3000")
    else
      redirect_to("http://#{subdomain}.jedappuae.herokuapp.com")
    end
  end

end
