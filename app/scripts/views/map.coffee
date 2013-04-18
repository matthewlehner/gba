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
      @mapControl = new MapControl(@el)
      @map = @mapControl.map

    addMarkers: ->
      @collection.each (item) =>
        @addMarker(item)

    addMarker: (item) ->
      lat = item.get 'lat'
      lng = item.get 'lng'
      @mapControl.addMarker(lat, lng).on 'click', (e) =>
        @clickMarker(e, item)

    clickMarker: (e, item) =>
      item.trigger('mapSelect', item)

  class mapView.controls extends Backbone.Layout

    template: 'map/controls'

  return mapView
