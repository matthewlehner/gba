define [ 
  'app'
  'models/item'
], (app, ItemModel) ->

  class ItemCollection extends Backbone.Collection
    model: ItemModel

    search: (params) ->
      @fetch
        data: params
        reset: true

    url: '/items'

  return ItemCollection
