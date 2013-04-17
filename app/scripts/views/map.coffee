define [
  'app'
  'leaflet'
], (app, Leaflet) ->
  mapView = {}

  class mapView.tiles extends Backbone.View
    className: 'tiles'

    afterRender: ->
      @map = L.map(@el).locate
        setView: true
        maxZoom: 16

      L.tileLayer('http://{s}.tiles.mapbox.com/v3/mpl.map-glvcefkt/{z}/{x}/{y}.png'
        attribution: 'Map data &copy; [...]'
        maxZoom: 18
      ).addTo @map

  class mapView.controls extends Backbone.View

    template: 'map/controls'

  return mapView
