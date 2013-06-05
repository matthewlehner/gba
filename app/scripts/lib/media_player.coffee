define [
  'app'
], (app) ->

  class MediaPlayer
    constructor:(@audioFiles) ->
      @createMediaObjects()
      @mediaPlaying = false

    createMediaObjects: ->
      @media ?= {}

      for file in @audioFiles
        @media[file['id']] = new Media(file['url'])

    clicked: ($el) ->
      media = @media[$el.data('audio-id')]
      if @mediaPlaying
        @pauseOrSwitch($el, media)
      else
        @play($el, media)

    play: ($el, media) ->
      $el.addClass 'playing'
      @mediaPlaying = media
      setTimeout ->
        media.play
          playAudioWhenScreenIsLocked: true
      , 50

    pauseOrSwitch: ($el, media) ->
      if media is @mediaPlaying
        if $el.hasClass('playing')
          @pause()
          $el.removeClass('playing')
        else
          @play($el, media)

      else
        @mediaPlaying.stop()
        $el.siblings().removeClass('playing')
        @play($el, media)

    pause: =>
      @mediaPlaying?.pause?()

    remove: =>
      for id, media in @media
        media.stop()
        media.release()


  return MediaPlayer
