class Item
  include Mongoid::Document
  
  field :posting_id, :type => Integer
  field :title
  field :href
  field :text
  field :img
  field :price
end
