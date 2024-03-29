require 'uri'

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
      if @store == nil
        @store = Store.where(subdomain: 'الجميلللنظارات').first
      end
      @domain = request.host.split('.')[1]
      if @store.phone && @store.name && @store.subdomain
        @category = Category.where(id: @store.category_id)
        @domain = request.host.split('.')[1]
        render :template => 'pages/view'
      else
        gohome
      end
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

  def custom_test
    subdomain = params[:subdomain]
    @page_showing = 'showing-page'
    page_name = subdomain
    @store = Store.where(subdomain: page_name).first
    @category = @store.category.name
    @domain = request.host.split('.')[1]
    render :template => 'pages/view'
  end

  def translate
    session[:lang] = session[:lang] == 'english' ? 'arabic' : 'english'
    redirect_to '/'
  end
end
