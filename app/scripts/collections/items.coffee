define [
  'app'
  'models/item'
], (app, ItemModel) ->

  class ItemCollection extends Backbone.Collection
    model: ItemModel

    initialize: ->
      @on 'reset', ->
        delete @typesFilter

    search: (params) ->
      @fetch
        data: params
        reset: true
        success: =>
          @trigger 'searchSuccessful'

      @trigger 'searching'

    url: '/items'

    comparator: (item) ->
      item.get 'distance'

    filterTypes: ->
      @typesFilter ?= @_getTypes()
      @typesFilter

    _getTypes: ->
      types = {'Buildings with audio': true}

      for type in _.uniq @pluck('type')
        types[type] = true

      types


  return ItemCollection
