define [
  'app'
], (app) ->

  class geoWatcher
    position: null
    timestamp:null

    constructor: ->
      @onSuccess = (event) =>
        @success event

      @onError = (event) =>
        @error event

      @watchID = navigator.geolocation.watchPosition(@onSuccess, @onError, { timeout: 30000 });

    unwatch: ->
      navigator.geolocation.clearWatch(@watchID);

    success: (position) ->
      @timestamp = new Date()
      @position =
        latitude: position.coords.latitude
        longitude: position.coords.longitude
        altitude: position.coords.altitude
        accuracy: position.coords.accuracy
        altitudeAccuracy: position.coords.altitudeAccuracy
        heading: position.coords.heading
        speed: position.coords.speed
        timestamp: position.timestamp

      app.trigger("geoWatcher:Success")

    error: (err) ->
      app.trigger("geoWatcher:Error")

    isValidLocation: () ->
      return  @position? &&
        !isNaN(@position.latitude) &&
        !isNaN(@position.longitude);

  return geoWatcher;

# onSuccess Callback
#   This method accepts a `Position` object, which contains
#   the current GPS coordinates
#
# function onSuccess(position) {
# var element = document.getElementById('geolocation');
# element.innerHTML = 'Latitude: '  + position.coords.latitude      + '<br />' +
# 'Longitude: ' + position.coords.longitude     + '<br />' +
# '<hr />'      + element.innerHTML;
# }
#
# onError Callback receives a PositionError object
#
# function onError(error) {
# alert('code: '    + error.code    + '\n' +
# 'message: ' + error.message + '\n');
# }
#
# // Options: throw an error if no update is received every 30 seconds.
# //
# var watchID = navigator.geolocation.watchPosition(onSuccess, onError, { timeout: 30000 });
