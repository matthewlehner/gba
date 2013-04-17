define [
  'app'
  'leaflet'
], (app, Leaflet) ->
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
      @map = L.map(@el,
        zoomControl: false
      ).locate
        setView: true
        maxZoom: 24

      L.tileLayer('http://{s}.tiles.mapbox.com/v3/mpl.map-glvcefkt/{z}/{x}/{y}.png'
        detectRetina: true
      ).addTo @map

    addMarkers: ->
      @options.items.each (item) =>
        @addMarker(item)

    addMarker: (item) ->
      lat = item.get 'lat'
      lng = item.get 'lng'
      marker = new L.Marker [lat, lng],
        icon: @markerIcon
      marker.addTo(@map)


  class mapView.controls extends Backbone.Layout

    template: 'map/controls'

  return mapView
