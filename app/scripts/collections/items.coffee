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
        success: =>
          @trigger 'searchSuccessful'

      @trigger 'searching'

    url: '/items'

  return ItemCollection
