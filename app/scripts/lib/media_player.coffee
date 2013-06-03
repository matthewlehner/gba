define [
  'app'
], (app) ->

  class MediaPlayer
    constructor:(@audioFiles) ->
      @createMediaObjects()
      @$elementPlaying = false

    createMediaObjects: ->
      @media ?= {}

      for file in @audioFiles
        k = file['id']
        v = new Media(file['url'])
        o = {k: v}
        _.extend @media, o

    clicked: ($el) ->
      if @$elementPlaying
        @pauseOrSwitch($el)
      else
        @play($el)

    play: ($el) ->
      @media[$el.data('audio-id')].play()
      $el.addClass 'playing'
      @$elementPlaying = $el

    pauseOrSwitch: ($el) ->
      if @$elementPlaying is $el
        @media[$el.data('audio-id')].pause()
        $el.removeClass('playing')
      else
        @media[@$elementPlaying.data('audio-id')].stop()
        @$elementPlaying.removeClass('playing')
        @play($el)

  return MediaPlayer
