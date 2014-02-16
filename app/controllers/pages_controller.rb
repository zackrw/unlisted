class PagesController < ApplicationController

  def catchall
    i18n()

    if is_home?(request.host)
      @page_showing = 'showing-home'
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
      redirect_to('http://jedapp.com')
    end
  end

  def goview
    host_parts = request.host.split('.')
    subdomain = params[:subdomain]
    if host_parts.include?('localhost')
      redirect_to("http://#{subdomain}.localhost:3000")
    else
      redirect_to("http://#{subdomain}.jedapp.com")
    end
  end

  def translate
    if session[:lang] == 'english'
      session[:lang] = 'arabic'
    else
      session[:lang] = 'english'
    end

    if is_home?(request.host)
      return gohome()
    else
      params[:subdomain] = request.host.split('.')[0]
      return goview()
    end
  end
end
