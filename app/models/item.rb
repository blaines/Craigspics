class Item
  include Mongoid::Document
  
  field :posting_id
  field :title
  field :href
  field :text
  field :img
  
end
