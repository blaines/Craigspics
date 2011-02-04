class SectionsController < ApplicationController
  # GET /sections
  # GET /sections.xml
  def index
    # @sections = Section.all

    agent = Mechanize.new
    page = agent.get('http://sfbay.craigslist.org/')
    @sections = page.links_with(:href => /^...\/$/)
    response.headers['Cache-Control'] = 'public, max-age=3600'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sections }
    end
  end

  # GET /sections/1
  # GET /sections/1.xml
  def show
    # @section = Section.find(params[:id])
    agent = Mechanize.new
    page = agent.get('http://sfbay.craigslist.org/'+params[:id])
    @links = page.links_with(:href => /\d{10}\.html$/)
    @items = @links.map do |link|
      posting_id = link.href.match(/(\d+).html$/)[1]
      item = Item.find_or_initialize_by(:posting_id => posting_id)
      if item.new_record?
        z = agent.get(link.href)
        hash = {:title => link.text, :href => link.href, :text => z.search("#userbody").first.text, :posting_id => posting_id}
        images = z.search("img")
        if images.size > 0
          hash[:img] = images[1]['src'] if images.size > 1
          hash[:img] ||= images.last['src']
        else
          hash[:img] = "https://secure.gravatar.com/avatar/61e77fef78d5c6da659fee96cdd4d791?s=140&d=https%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-140.png"
        end
        item.attributes = hash
        item.save
      end
      item
    end
    # @items.delete_if {|a| a[:img] == "https://secure.gravatar.com/avatar/61e77fef78d5c6da659fee96cdd4d791?s=140&d=https%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-140.png" }
    response.headers['Cache-Control'] = 'public, max-age=300'
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @section }
    end
  end

  # GET /sections/new
  # GET /sections/new.xml
  def search
    agent = Mechanize.new
    page = agent.get("http://sfbay.craigslist.org/search/#{params[:id]}?query=#{params[:q].gsub(/\s/,'+')}&srchType=A&minAsk=&maxAsk=")
    @links = page.links_with(:href => /\d{10}\.html$/)
    @items = @links.map do |link|
      posting_id = link.href.match(/(\d+).html$/)[1]
      item = Item.find_or_initialize_by(:posting_id => posting_id)
      if item.new_record?
        z = agent.get(link.href)
        hash = {:title => link.text, :href => link.href, :text => z.search("#userbody").first.text, :posting_id => posting_id}
        images = z.search("img")
        if images.size > 0
          hash[:img] = images[1]['src'] if images.size > 1
          hash[:img] ||= images.last['src']
        else
          hash[:img] = "https://secure.gravatar.com/avatar/61e77fef78d5c6da659fee96cdd4d791?s=140&d=https%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-140.png"
        end
        item.attributes = hash
        item.save
      end
      item
    end

    respond_to do |format|
      format.html { render :show }
      format.xml  { render :xml => @section }
    end
  end

  # GET /sections/1/edit
  def edit
    @section = Section.find(params[:id])
  end

  # POST /sections
  # POST /sections.xml
  def create
    @section = Section.new(params[:section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to(@section, :notice => 'Section was successfully created.') }
        format.xml  { render :xml => @section, :status => :created, :location => @section }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sections/1
  # PUT /sections/1.xml
  def update
    @section = Section.find(params[:id])

    respond_to do |format|
      if @section.update_attributes(params[:section])
        format.html { redirect_to(@section, :notice => 'Section was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @section.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sections/1
  # DELETE /sections/1.xml
  def destroy
    @section = Section.find(params[:id])
    @section.destroy

    respond_to do |format|
      format.html { redirect_to(sections_url) }
      format.xml  { head :ok }
    end
  end
end
