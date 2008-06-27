class CoversController < ApplicationController
  
  def index
    if params[:keywords]
      @discogs_urls = Cover.find_from_discogs(params[:keywords]) 
      @albumart_urls = Cover.find_from_albumart(params[:keywords])
    end
  end
  
end
