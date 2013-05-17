define [ 
  'app'
  'lib/distance_helper'
], (app, DistanceHelper) ->

  class ItemModel extends Backbone.Model
    initialize: ->
      @setDistance()
      @on 'addMarker', @hasMarker

    hasMarker: (marker) =>
      @marker = marker
      if app.mapControl.currentLocation?
        @setDistance()
      else
        app.on 'locationfound', @setDistance

    setDistance: =>
      if app.mapControl.currentLocation?
        distance = app.mapControl.getDistance
          'lat': @get 'lat'
          'lng': @get 'lng'
        @set 'distance', distance
        @set 'human_distance', new DistanceHelper(distance).humanize()

  return ItemModel
