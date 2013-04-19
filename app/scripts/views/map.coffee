define [
  'app'
  'lib/map_control'
], (app, MapControl) ->
  MapView = {}

  class MapTiles extends Backbone.Layout
    className: 'tiles'

    beforeRender: ->
      @markerIcon = new L.DivIcon
        className: 'map-marker'

      @listenTo @collection,
        'reset': @addMarkers
        'add': @addMarker
        'fetch': ->
          # TODO something with fetched locations
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

      else
        console.count("noLatLng")

    clickMarker: (e, item) =>
      item.trigger('mapSelect', item)

  return MapTiles
