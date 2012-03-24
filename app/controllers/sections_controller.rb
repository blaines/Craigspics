class SectionsController < ApplicationController
  # GET /sections
  # GET /sections.xml
  def index
    # @sections = Section.all

    agent = Mechanize.new
    page = agent.get('http://www.craigslist.org/about/sites')
    # page = agent.get("http://#{location}.craigslist.org/")
    @domains = page.links_with(:href => /http:\/\/.+\.craigslist\.org/i)
    # debugger
    response.headers['Cache-Control'] = 'public, max-age=6400'
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /sections
  # GET /sections.xml
  def city
    # @sections = Section.all

    agent = Mechanize.new
    page = agent.get("http://#{params[:city]}.craigslist.org/")
    # debugger
    @sections = page.links_with(:href => /^[a-z]{3}\/$/)
    # debugger
    response.headers['Cache-Control'] = 'public, max-age=6400'
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /sections/new
  # GET /sections/new.xml
  # link.href.match(/(\d+).html$/)[1]
  def search
    safe_query = params[:q].gsub(/\s/,'+') if params[:q]
    safe_query ||= ""
    safe_params = {}
    safe_params[:query] = safe_query if safe_query
    safe_params[:minAsk] = params[:min_ask] if params[:min_ask]
    safe_params[:maxAsk] = params[:max_ask] if params[:max_ask]
    safe_params[:s] = params[:s] if params[:s]
    safe_params[:hasPic] = 1
    @s = params[:s] || 0
    agent = Mechanize.new
    uri = "http://#{params[:city]}.craigslist.org/search/#{params[:category]}?#{safe_params.to_query}"
    puts uri
    puts ">>>> #### >>>> "+uri
    page = agent.get(uri)
    @links = page.links_with(:href => /\d{10}\.html$/)
    @items = @links.map do |link|
      {:id => link.href.match(/(\d+).html$/)[1], :link => link.href}
    end
    response.headers['Cache-Control'] = 'public, max-age=6400'
    respond_to do |format|
      format.html { render :show }
    end
  end
end
