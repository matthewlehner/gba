define [ 
  'app'
  'lib/distance_helper'
], (app, DistanceHelper) ->

  class ItemModel extends Backbone.Model
    initialize: ->
      @setDistance()
      @on 'addMarker', @hasMarker
      @on 'change', @saveLocal
      @on 'fetching', @loadLocal

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

      else
        @set 'human_distance', 'No Geolocation'


    hasAudioFile: ->
      @get('audio_count') > 0

    loadLocal: ->
      result = localStorage["item-#{@id}"]

      if result?
        @set JSON.parse(result),
          silent: true

    saveLocal: ->
      result = JSON.stringify(@toJSON())
      localStorage["item-#{@id}"] = result

    fetched: ->
      _.chain(@attributes)
      .keys()
      .intersection(['address', 'city', 'country', 'description', 'summary', 'audio_files', 'pictures'])
      .value()
      .length > 0



  return ItemModel
