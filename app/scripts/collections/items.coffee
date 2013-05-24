define [
  'app'
  'models/item'
], (app, ItemModel) ->

  class ItemCollection extends Backbone.Collection
    model: ItemModel

    initialize: ->
      @on 'reset', =>
        @typesFilter = null

      @on 'refilter', =>
        @cachedModels = null

    search: (params) ->
      @fetch
        data: params
        reset: true
        success: =>
          @trigger 'searchSuccessful'

          if $('#main').hasClass 'map'
            app.trigger 'viewToggle'

      @trigger 'searching'

    url: 'http://greenbuildingbrain.org/api/v1/items'

    comparator: (item) ->
      item.get 'distance'

    filterTypes: ->
      @typesFilter ?= @_getTypes()
      @typesFilter

    _getTypes: ->
      types = {'Show only buildings with audio': false}

      for type in _.uniq @pluck('filter')
        types[type] = true

      types

    typesFiltered: ->
      _.chain(@filterTypes())
      .map (num, key) ->
        if num is false
          return key
        else
          return null
      .without('Show only buildings with audio')
      .compact()
      .value()

    filteredModels: ->
      if @cachedModels?
        @cachedModels
      else
        @performFilter()

    performFilter: ->
      models = _.chain(@models)

      if @filterTypes()['Show only buildings with audio'] is true
        models = models.filter (item) ->
          return (item.get('audio_count') > 0)

      typesFiltered = @typesFiltered()
      if typesFiltered.length > 0
        models = models.filter (item) ->
          return !_.contains(typesFiltered, item.get('filter'))

      @cachedModels = models

  return ItemCollection
