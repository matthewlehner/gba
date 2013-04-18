define [ 
  'app'
  'models/item'
], (app, itemModel) ->

  class itemCollection extends Backbone.Collection
    model: itemModel

    url: '//gbb.dev/items.json'

  return itemCollection
