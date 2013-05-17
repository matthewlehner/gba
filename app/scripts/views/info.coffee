define [
  'app'
], (app) ->
  class InfoView extends Backbone.Layout
    template: 'info_window'

    events:
      'click footer': 'dismiss'

    dismiss: =>
      @$el.addClass 'fade'

      setTimeout =>
        @remove()
      , 210

    serialize: ->
      attrs = {}

      if @options.content?
        _.extend attrs,
          content: @options.content

      if @options.header?
        _.extend attrs,
          header: @options.header

      return attrs

  return InfoView
