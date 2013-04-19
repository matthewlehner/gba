define [
  'app'
  'lib/map_control'
], (app, MapControl) ->
  mapView = {}

  class mapView.tiles extends Backbone.Layout
    className: 'tiles'

    beforeRender: ->
      @markerIcon = new L.DivIcon
        className: 'map-marker'

      @listenTo @collection,
        'reset': @addMarkers
        'add': @addMarker
        'fetch': ->
          console.log 'getting locations'

    afterRender: ->
      app.mapControl = new MapControl(@el)

    addMarkers: ->
      @collection.each (item) =>
        @addMarker(item)

    addMarker: (item) ->
      lat = item.get 'lat'
      lng = item.get 'lng'

      if lat? and lng?
        app.mapControl.addMarker(lat, lng).on 'click', (e) =>
          @clickMarker(e, item)

    clickMarker: (e, item) =>
      item.trigger('mapSelect', item)

  class mapView.controls extends Backbone.Layout
    template: 'map/controls'

  class mapView.items extends Backbone.Layout
    initialize: ->
      @listenTo @collection,
        'reset': @addItems
        'mapSelect': @selectItem

    selectItem: (item) ->
      selectedView = @getView
        model: item

      if @currentView is selectedView
        @$el.parent().addClass('hidden')
        @currentView = null
      else
        @currentView = selectedView
        @currentView.$el.siblings()
          .removeClass('current')
        .end()
        .addClass('current')

        @$el.parent().removeClass('hidden')

    addItems: (collection, render) =>
      @collection.each (item) =>
        @insertView new Item
          className: "item id-#{item.id}"
          model: item

      unless render is false
        @render()

  class Item extends Backbone.Layout
    template: 'map/item'

    events:
      'click': 'openItem'
      'click .arrow': 'closeItem'

    openItem: =>
      return if @open

      @open = true
      @model.trigger 'open', @model

    closeItem: =>
      return unless @open

      @model.trigger 'close', @model
      @open = false

    serialize: ->
      @model.toJSON()

  return mapView
