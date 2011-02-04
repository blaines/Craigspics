class ItemsController < ApplicationController
  # GET /items
  # GET /items.xml
  def index
    @items = Item.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @items }
    end
  end

  # GET /items/1
  # GET /items/1.xml
  def show
    link = params[:link]
    posting_id = params[:id]
    
    @item = Item.find_or_initialize_by(:posting_id => posting_id)
    if @item.new_record?
      agent = Mechanize.new
      z = agent.get(link)
      hash = {:title => z.search("h2").first.text, :href => link, :text => z.search("#userbody").first.text, :posting_id => posting_id}
      images = z.search("img")
      if images.size > 0
        hash[:img] = images[1]['src'] if images.size > 1
        hash[:img] ||= images.last['src']
      else
        hash[:img] = "https://secure.gravatar.com/avatar/61e77fef78d5c6da659fee96cdd4d791?s=140&d=https%3A%2F%2Fgithub.com%2Fimages%2Fgravatars%2Fgravatar-140.png"
      end
      @item.attributes = hash
      @item.save
    end
    

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.json { render :json => @item }
    end
  end

  # GET /items/new
  # GET /items/new.xml
  def new
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  # POST /items
  # POST /items.xml
  def create
    @item = Item.new(params[:item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to(@item, :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item, :notice => 'Item was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(items_url) }
      format.xml  { head :ok }
    end
  end
end
