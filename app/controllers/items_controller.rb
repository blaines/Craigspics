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
    
    r = REDIS.get posting_id
    if r
      @item = Item.new(ActiveSupport::JSON.decode r) # Instantiating a fake Item :D
    else
      @item = Item.find_or_initialize_by(:posting_id => posting_id)
      if @item.new_record?
        agent = Mechanize.new
        z = agent.get(link)
        t = z.search("h2").first.text.match(/\$([1234567890\.]+)\s/)
        price = t[1] if t
        price ||= 0
        hash = {:title => z.search("h2").first.text, :price => price, :href => link, :text => z.search("#userbody").first.text, :posting_id => posting_id}
        images = z.search("img")
        if images.size > 0
          hash[:img] = images[1]['src'] if images.size > 1
          hash[:img] ||= images.last['src']
        else
          hash[:img] = ""
        end
        @item.attributes = hash
        @item.save
        REDIS.setex @item.posting_id, 1.hour.to_i, {:href => @item.href, :img => @item.img, :price => @item.price}.to_json
      end
    end
    
    response.headers['Cache-Control'] = 'public, max-age=6400'
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
      format.json { render :json => @item }
    end
  end
end
