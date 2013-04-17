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

      @listenTo @options.items,
        'reset': @addMarkers
        'fetch': ->
          console.log 'getting locations'

    afterRender: ->
      @mapControl = new MapControl(@el)
      @map = @mapControl.map

    addMarkers: ->
      @options.items.each (item) =>
        @addMarker(item)

    addMarker: (item) ->
      lat = item.get 'lat'
      lng = item.get 'lng'
      @mapControl.addMarker(lat, lng).on 'click', (e) =>
        @clickMarker(e, item)

    clickMarker: (e, item) =>
      item.trigger('mapFocus')

  class mapView.controls extends Backbone.Layout

    template: 'map/controls'

  return mapView
