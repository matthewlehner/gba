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
        'refilter'     : @resetMarkers
        'reset'        : @resetMarkers
        'add'          : @addSingleMarker
        'selectResult' : @focusMarker
        'remove'       : @removeMarker

    afterRender: ->
      @mapControl = new MapControl(@el)
      app.mapControl = @mapControl

    resetMarkers: ->
      @mapControl.clearMarkers()
      @addMarkers()

    addMarkers: ->
      @collection.filteredModels().each (item) =>
        @createMarker(item)

      @addMarkersToMap()
      return this

    createMarker: (item) ->
      attrs = new MarkerAttrs(item)

      marker = @mapControl.createMarker(attrs)
      if marker?
        marker.on 'click', (e) =>
          @clickMarker(e, item)

        # let the model know that it has a marker.
        item.trigger 'addMarker', marker

      return this

    addMarkersToMap: ->
      @mapControl.renderMarkers()
      @collection.trigger 'markersAdded'

    addSingleMarker: ->
      return if @waiting?
      @waiting = true
      window.setTimeout =>
        @waiting = null
        @collection.trigger 'refilter'
        @resetMarkers()
      , 200

    clickMarker: (e, item) =>
      item.trigger('mapSelect', item)

    focusMarker: (item) =>
      @mapControl.map.panTo item.marker.getLatLng()

    removeMarker: (item) =>
      @mapControl.items.removeLayer(item.marker)

  class MarkerAttrs
    constructor: (item) ->
      @lat = item.get 'lat'
      @lng = item.get 'lng'
      @className = item.mapMarkerClass()

  return MapTiles
