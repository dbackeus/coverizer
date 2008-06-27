class Cover
  
  def self.find(keywords)
    find_from_discogs(keywords)
  end
  
  # ===============
  # = Discogs.org =
  # ===============
  
  def self.find_from_discogs(keywords)
    keywords = keywords.downcase.split
    url = "http://www.discogs.com/search?type=releases&q=#{keywords.join('+')}"
    
    doc = Hpricot( open url )
    
    # Grab all items in the list that actually has the keywords in the link-text
    list = doc.search('#data ol li').select do |li|
      ok = true
      keywords.each do |keyword|
        ok = false unless (li/'a').to_html.downcase.include? keyword
      end
      ok
    end
    
    # Grab all the urls form the list
    urls = list.collect { |li| "http://" + (li/'span').last.inner_html }
    
    # Grabs the urls for all 'more image' pages availible
    image_pages_urls = urls.collect do |url|
      album_page = Hpricot( open url )
      "http://www.discogs.com" + (album_page/'a').detect { |a| a.to_html.include? 'viewimages' }['href'] rescue nil
    end.compact
    
    image_urls = image_pages_urls.collect do |url|
      image_page = Hpricot( open url )
      (image_page/'p img').collect { |img| img['src'] }
    end.flatten
  end
  
  # ================
  # = Albumart.org =
  # ================
  
  def self.find_from_albumart(keywords)
    keywords = keywords.downcase.split
    url = "http://www.albumart.org/index.php?srchkey=#{keywords.join('+')}&itempage=1&newsearch=1&searchindex=Music"
    
    doc = Hpricot( open url )
    
    # Grab all the links to external images
    (doc/'a.thickbox').collect { |a| a['href'] }
  end
  
  # ===================
  # = Allcdcovers.com =
  # ===================
  
  def self.find_from_allcdcovers(keywords)
    # TODO
  end
  
end