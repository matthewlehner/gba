define [
  'app'
  'models/item'
], (app, ItemModel) ->

  class ItemCollection extends Backbone.Collection
    model: ItemModel

    initialize: ->
      @on 'reset', =>
        @typesFilter = null

    search: (params) ->
      @fetch
        data: params
        reset: true
        success: =>
          @trigger 'searchSuccessful'

          if $('#main').hasClass 'map'
            app.trigger 'viewToggle'

      @trigger 'searching'

    url: '/items'

    comparator: (item) ->
      item.get 'distance'

    filterTypes: ->
      @typesFilter ?= @_getTypes()
      @typesFilter

    _getTypes: ->
      types = {'Show only buildings with audio': false}

      for type in _.uniq @pluck('type')
        types[type] = true

      types

    typesFiltered: ->
      _.chain(@filterTypes())
      .map (type, value) ->
        return value ? type : null
      .without('Show only buildings with audio')
      .compact()
      .value()

    filteredModels: ->
      models = _.chain(@models)

      if @filterTypes()['Show only buildings with audio'] is true
        models = models.filter (item) ->
          return (item.get('audio_count') > 0)

      typesFiltered = @typesFiltered()
      if typesFiltered.length > 0
        models = models.filter (item) ->
          return _.include typesFiltered, item.get('type')

      models

  return ItemCollection
