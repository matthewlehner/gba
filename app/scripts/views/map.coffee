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
        maxZoom: 16

      L.tileLayer('http://{s}.tiles.mapbox.com/v3/mpl.map-glvcefkt/{z}/{x}/{y}.png'
        detectRetina: true
        maxZoom: 24
      ).addTo @map

      @map.on('locationfound', @onLocationFound)

    onLocationFound: (e) =>
      radius = e.accuracy / 2

      circle = L.circle e.latlng, radius,
        weight: 1

      icon = new L.DivIcon
        className: 'map-current-location'

      centerPoint = new L.Marker e.latlng,
        icon: icon

      layers = new L.LayerGroup
      layers.addLayer circle
      layers.addLayer centerPoint
      layers.addTo(@map);


    addMarkers: ->
      @options.items.each (item) =>
        @addMarker(item)

    addMarker: (item) ->
      lat = item.get 'lat'
      lng = item.get 'lng'
      marker = new L.Marker [lat, lng],
        icon: @markerIcon
      marker.addTo(@map).on 'click', (e) =>
        @clickMarker(e, item)

    clickMarker: (e, item) ->


  class mapView.controls extends Backbone.Layout

    template: 'map/controls'

  return mapView
